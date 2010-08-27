#
# render(tag) might compare two very large strings, with lots of whitespace
# differences which would be hard to diagnose. So use the Comparison module to
# zero in on the bug.
#
module Spec::Rails::Matchers
  class RenderTags

    # Guard against double definitions
    unless method_defined?(:_old_matches?)
      alias_method :_old_matches?, :matches?
      alias_method :_old_failure_message, :failure_message

      # If comparison was just a straight '==' then redo the comparison
      # using the comparison class, and save an error message
      def matches?(page)
        _old_matches? page
        if @expected
          comparison = Comparison.new(@expected, @actual)
          @error_message = comparison.message
          comparison.same?
        end
      end

      # Return the error message from Comparison if it was saved
      def failure_message
        return @error_message unless @error_message.nil?
        _old_failure_message
      end
    end

  end
end
