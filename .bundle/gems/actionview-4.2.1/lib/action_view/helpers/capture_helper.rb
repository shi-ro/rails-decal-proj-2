require 'active_support/core_ext/string/output_safety'

module ActionView
  # = Action View Capture Helper
  module Helpers
    # CaptureHelper exposes methods to let you extract generated markup which
    # can be used in other parts of a template or layout file.
    #
    # It provides a method to capture blocks into variables through capture and
    # a way to capture a block of markup for use in a layout through content_for.
    module CaptureHelper
      # The capture method allows you to extract part of a template into a
      # variable. You can then use this variable anywhere in your templates or layout.
      #
      # The capture method can be used in ERB templates...
      #
      #   <% @greeting = capture do %>
      #     Welcome to my shiny new web page!  The date and time is
      #     <%= Time.now %>
      #   <% end %>
      #
      # ...and Builder (RXML) templates.
      #
      #   @timestamp = capture do
      #     "The current timestamp is #{Time.now}."
      #   end
      #
      # You can then use that variable anywhere else. For example:
      #
      #   <html>
      #   <head><title><%= @greeting %></title></head>
      #   <body>
      #   <b><%= @greeting %></b>
      #   </body></html>
      #
      def capture(*args)
        value = nil
        buffer = with_output_buffer { value = yield(*args) }
        if string = buffer.presence || value and string.is_a?(String)
          ERB::Util.html_escape string
        end
      end

      # Calling content_for stores a block of markup in an identifier for later use.
      # In order to access this stored content in other templates, helper modules
      # or the layout, you would pass the identifier as an argument to <tt>content_for</tt>.
      #
      # Note: <tt>yield</tt> can still be used to retrieve the stored content, but calling
      # <tt>yield</tt> doesn't work in helper modules, while <tt>content_for</tt> does.
      #
      #   <% content_for :not_authorized do %>
      #     alert('You are not authorized to do that!')
      #   <% end %>
      #
      # You can then use <tt>content_for :not_authorized</tt> anywhere in your templates.
      #
      #   <%= content_for :not_authorized if current_user.nil? %>
      #
      # This is equivalent to:
      #
      #   <%= yield :not_authorized if current_user.nil? %>
      #
      # <tt>content_for</tt>, however, can also be used in helper modules.
      #
      #   module StorageHelper
      #     def stored_content
      #       content_for(:storage) || "Your storage is empty"
      #     end
      #   end
      #
      # This helper works just like normal helpers.
      #
      #   <%= stored_content %>
      #
      # You can also use the <tt>yield</tt> syntax alongside an existing call to
      # <tt>yield</tt> in a layout. For example:
      #
      #   <%# This is the layout %>
      #   <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      #   <head>
      #     <title>My Website</title>
      #     <%= yield :script %>
      #   </head>
      #   <body>
      #     <%= yield %>
      #   </body>
      #   </html>
      #
      # And now, we'll create a view that has a <tt>content_for</tt> call that
      # creates the <tt>script</tt> identifier.
      #
      #   <%# This is our view %>
      #   Please login!
      #
      #   <% content_for :script do %>
      #     <script>alert('You are not authorized to view this page!')</script>
      #   <% end %>
      #
      # Then, in another view, you could to do something like this:
      #
      #   <%= link_to 'Logout', action: 'logout', remote: true %>
      #
      #   <% content_for :script do %>
      #     <%= javascript_include_tag :defaults %>
      #   <% end %>
      #
      # That will place +script+ tags for your default set of JavaScript files on the page;
      # this technique is useful if you'll only be using these scripts in a few views.
      #
      # Note that content_for concatenates (default) the blocks it is given for a particular
      # identifier in order. For example:
      #
      #   <% content_for :navigation do %>
      #     <li><%= link_to 'Home', action: 'index' %></li>
      #   <% end %>
      #
      #  And in other place:
      #
      #   <% content_for :navigation do %>
      #     <li><%= link_to 'Login', action: 'login' %></li>
      #   <% end %>
      #
      # Then, in another template or layout, this code would render both links in order:
      #
      #   <ul><%= content_for :navigation %></ul>
      #
      # If the flush parameter is true content_for replaces the blocks it is given. For example:
      #
      #   <% content_for :navigation do %>
      #     <li><%= link_to 'Home', action: 'index' %></li>
      #   <% end %>
      #
      #   <%#  Add some other content, or use a different template: %>
      #
      #   <% content_for :navigation, flush: true do %>
      #     <li><%= link_to 'Login', action: 'login' %></li>
      #   <% end %>
      #
      # Then, in another template or layout, this code would render only the last link:
      #
      #   <ul><%= content_for :navigation %></ul>
      #
      # Lastly, simple content can be passed as a parameter:
      #
      #   <% content_for :script, javascript_include_tag(:defaults) %>
      #
      # WARNING: content_for is ignored in caches. So you shouldn't use it for elements that will be fragment cached.
      def content_for(name, content = nil, options = {}, &block)
        if content || block_given?
          if block_given?
            options = content if content
            content = capture(&block)
          end
          if content
            options[:flush] ? @view_flow.set(name, content) : @view_flow.append(name, content)
          end
          nil
        else
          @view_flow.get(name).presence
        end
      end

      # The same as +content_for+ but when used with streaming flushes
      # straight back to the layout. In other words, if you want to
      # concatenate several times to the same buffer when rendering a given
      # template, you should use +content_for+, if not, use +provide+ to tell
      # the layout to stop looking for more contents.
      def provide(name, content = nil, &block)
        content = capture(&block) if block_given?
        result = @view_flow.append!(name, content) if content
        result unless content
      end

      # content_for? checks whether any content has been captured yet using `content_for`.
      # Useful to render parts of your layout differently based on what is in your views.
      #
      #   <%# This is the layout %>
      #   <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      #   <head>
      #     <title>My Website</title>
      #     <%= yield :script %>
      #   </head>
      #   <body class="<%= content_for?(:right_col) ? 'two-column' : 'one-column' %>">
      #     <%= yield %>
      #     <%= yield :right_col %>
      #   </body>
      #   </html>
      def content_for?(name)
        @view_flow.get(name).present?
      end

      # Use an alternate output buffer for the duration of the block.
      # Defaults to a new empty string.
      def with_output_buffer(buf = nil) #:nodoc:
        unless buf
          buf = ActionView::OutputBuffer.new
          buf.force_encoding(output_buffer.encoding) if output_buffer
        end
        self.output_buffer, old_buffer = buf, output_buffer
        yield
        output_buffer
      ensure
        self.output_buffer = old_buffer
      end
    end
  end
end
