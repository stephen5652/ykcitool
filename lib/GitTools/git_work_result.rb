module YKFastlane

  module GitAnalysis
    class GitWorkResult
      attr_reader :status, :data, :message, :detail

      def initialize(status, data, message, detail)
        @status = false
        @data = data
        @message = message
        @detail = detail
      end
    end
  end
end