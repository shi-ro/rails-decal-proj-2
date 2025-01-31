module ActiveRecord
  # = Active Record Counter Cache
  module CounterCache
    extend ActiveSupport::Concern

    module ClassMethods
      # Resets one or more counter caches to their correct value using an SQL
      # count query. This is useful when adding new counter caches, or if the
      # counter has been corrupted or modified directly by SQL.
      #
      # ==== Parameters
      #
      # * +id+ - The id of the object you wish to reset a counter on.
      # * +counters+ - One or more association counters to reset. Association name or counter name can be given.
      #
      # ==== Examples
      #
      #   # For Post with id #1 records reset the comments_count
      #   Post.reset_counters(1, :comments)
      def reset_counters(id, *counters)
        object = find(id)
        counters.each do |counter_association|
          has_many_association = _reflect_on_association(counter_association)
          unless has_many_association
            has_many = reflect_on_all_associations(:has_many)
            has_many_association = has_many.find { |association| association.counter_cache_column && association.counter_cache_column.to_sym == counter_association.to_sym }
            counter_association = has_many_association.plural_name if has_many_association
          end
          raise ArgumentError, "'#{self.name}' has no association called '#{counter_association}'" unless has_many_association

          if has_many_association.is_a? ActiveRecord::Reflection::ThroughReflection
            has_many_association = has_many_association.through_reflection
          end

          foreign_key  = has_many_association.foreign_key.to_s
          child_class  = has_many_association.klass
          reflection   = child_class._reflections.values.find { |e| e.belongs_to? && e.foreign_key.to_s == foreign_key && e.options[:counter_cache].present? }
          counter_name = reflection.counter_cache_column

          stmt = unscoped.where(arel_table[primary_key].eq(object.id)).arel.compile_update({
            arel_table[counter_name] => object.send(counter_association).count(:all)
          }, primary_key)
          connection.update stmt
        end
        return true
      end

      # A generic "counter updater" implementation, intended primarily to be
      # used by increment_counter and decrement_counter, but which may also
      # be useful on its own. It simply does a direct SQL update for the record
      # with the given ID, altering the given hash of counters by the amount
      # given by the corresponding value:
      #
      # ==== Parameters
      #
      # * +id+ - The id of the object you wish to update a counter on or an Array of ids.
      # * +counters+ - A Hash containing the names of the fields
      #   to update as keys and the amount to update the field by as values.
      #
      # ==== Examples
      #
      #   # For the Post with id of 5, decrement the comment_count by 1, and
      #   # increment the action_count by 1
      #   Post.update_counters 5, comment_count: -1, action_count: 1
      #   # Executes the following SQL:
      #   # UPDATE posts
      #   #    SET comment_count = COALESCE(comment_count, 0) - 1,
      #   #        action_count = COALESCE(action_count, 0) + 1
      #   #  WHERE id = 5
      #
      #   # For the Posts with id of 10 and 15, increment the comment_count by 1
      #   Post.update_counters [10, 15], comment_count: 1
      #   # Executes the following SQL:
      #   # UPDATE posts
      #   #    SET comment_count = COALESCE(comment_count, 0) + 1
      #   #  WHERE id IN (10, 15)
      def update_counters(id, counters)
        updates = counters.map do |counter_name, value|
          operator = value < 0 ? '-' : '+'
          quoted_column = connection.quote_column_name(counter_name)
          "#{quoted_column} = COALESCE(#{quoted_column}, 0) #{operator} #{value.abs}"
        end

        unscoped.where(primary_key => id).update_all updates.join(', ')
      end

      # Increment a numeric field by one, via a direct SQL update.
      #
      # This method is used primarily for maintaining counter_cache columns that are
      # used to store aggregate values. For example, a DiscussionBoard may cache
      # posts_count and comments_count to avoid running an SQL query to calculate the
      # number of posts and comments there are, each time it is displayed.
      #
      # ==== Parameters
      #
      # * +counter_name+ - The name of the field that should be incremented.
      # * +id+ - The id of the object that should be incremented or an Array of ids.
      #
      # ==== Examples
      #
      #   # Increment the post_count column for the record with an id of 5
      #   DiscussionBoard.increment_counter(:post_count, 5)
      def increment_counter(counter_name, id)
        update_counters(id, counter_name => 1)
      end

      # Decrement a numeric field by one, via a direct SQL update.
      #
      # This works the same as increment_counter but reduces the column value by
      # 1 instead of increasing it.
      #
      # ==== Parameters
      #
      # * +counter_name+ - The name of the field that should be decremented.
      # * +id+ - The id of the object that should be decremented or an Array of ids.
      #
      # ==== Examples
      #
      #   # Decrement the post_count column for the record with an id of 5
      #   DiscussionBoard.decrement_counter(:post_count, 5)
      def decrement_counter(counter_name, id)
        update_counters(id, counter_name => -1)
      end
    end

    protected

      def actually_destroyed?
        @_actually_destroyed
      end

      def clear_destroy_state
        @_actually_destroyed = nil
      end

    private

      def _create_record(*)
        id = super

        each_counter_cached_associations do |association|
          if send(association.reflection.name)
            association.increment_counters
            @_after_create_counter_called = true
          end
        end

        id
      end

      def destroy_row
        affected_rows = super

        if affected_rows > 0
          each_counter_cached_associations do |association|
            foreign_key = association.reflection.foreign_key.to_sym
            unless destroyed_by_association && destroyed_by_association.foreign_key.to_sym == foreign_key
              if send(association.reflection.name)
                association.decrement_counters
              end
            end
          end
        end

        affected_rows
      end

      def each_counter_cached_associations
        _reflections.each do |name, reflection|
          yield association(name.to_sym) if reflection.belongs_to? && reflection.counter_cache_column
        end
      end

  end
end
