module Mail
  module Matchers
    def have_sent_email
      HasSentEmailMatcher.new(self)
    end

    class HasSentEmailMatcher
      def initialize(_context)
      end

      def matches?(subject)
        matching_deliveries = filter_matched_deliveries(Mail::TestMailer.deliveries)
        !(matching_deliveries.empty?)
      end

      def from(sender)
        @sender = sender
        self
      end

      def to(recipient_or_list)
        @recipients ||= []

        if recipient_or_list.kind_of?(Array)
          @recipients += recipient_or_list
        else
          @recipients << recipient_or_list
        end
        self
      end

      def cc(recipient_or_list)
        @copy_recipients ||= []

        if recipient_or_list.kind_of?(Array)
          @copy_recipients += recipient_or_list
        else
          @copy_recipients << recipient_or_list
        end
        self
      end

      def bcc(recipient_or_list)
        @blind_copy_recipients ||= []

        if recipient_or_list.kind_of?(Array)
          @blind_copy_recipients += recipient_or_list
        else
          @blind_copy_recipients << recipient_or_list
        end
        self
      end


      def with_subject(subject)
        @subject = subject
        self
      end

      def matching_subject(subject_matcher)
        @subject_matcher = subject_matcher
        self
      end

      def with_body(body)
        @body = body
        self
      end

      def matching_body(body_matcher)
        @body_matcher = body_matcher
        self
      end

      def description
        result = "send a matching email"
        result
      end

      def failure_message
        result = "Expected email to be sent "
        result += explain_expectations
        result += dump_deliveries
        result
      end

      def failure_message_when_negated
        result = "Expected no email to be sent "
        result += explain_expectations
        result += dump_deliveries
        result
      end

      protected

      def filter_matched_deliveries(deliveries)
        candidate_deliveries = deliveries

        %w(sender recipients copy_recipients blind_copy_recipients subject subject_matcher body body_matcher).each do |modifier_name|
          next unless instance_variable_defined?("@#{modifier_name}")
          candidate_deliveries = candidate_deliveries.select{|matching_delivery| self.send("matches_on_#{modifier_name}?", matching_delivery)}
        end

        candidate_deliveries
      end

      def matches_on_sender?(delivery)
        delivery.from.include?(@sender)
      end

      def matches_on_recipients?(delivery)
        @recipients.all? {|recipient| delivery.to.include?(recipient) }
      end

      def matches_on_copy_recipients?(delivery)
        @copy_recipients.all? {|recipient| delivery.cc.include?(recipient) }
      end

      def matches_on_blind_copy_recipients?(delivery)
        @blind_copy_recipients.all? {|recipient| delivery.bcc.include?(recipient) }
      end

      def matches_on_subject?(delivery)
        delivery.subject == @subject
      end

      def matches_on_subject_matcher?(delivery)
        @subject_matcher.match delivery.subject
      end

      def matches_on_body?(delivery)
        delivery.body == @body
      end

      def matches_on_body_matcher?(delivery)
        @body_matcher.match delivery.body.raw_source
      end

      def explain_expectations
        result = ''
        result += "from #{@sender} " if instance_variable_defined?('@sender')
        result += "to #{@recipients.inspect} " if instance_variable_defined?('@recipients')
        result += "cc #{@copy_recipients.inspect} " if instance_variable_defined?('@copy_recipients')
        result += "bcc #{@blind_copy_recipients.inspect} " if instance_variable_defined?('@blind_copy_recipients')
        result += "with subject \"#{@subject}\" " if instance_variable_defined?('@subject')
        result += "with subject matching \"#{@subject_matcher}\" " if instance_variable_defined?('@subject_matcher')
        result += "with body \"#{@body}\" " if instance_variable_defined?('@body')
        result += "with body matching \"#{@body_matcher}\" " if instance_variable_defined?('@body_matcher')
        result
      end

      def dump_deliveries
        "(actual deliveries: " + Mail::TestMailer.deliveries.inspect + ")"
      end
    end
  end
end
