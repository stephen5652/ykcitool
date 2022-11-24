require 'actions/YKFastlaneExecute'

module YKFastlane

  class YKServiceHttp < YKFastlane::SubCommandBase
    require 'HttpService/HttpServiceHelper'
    include YKHttpModule::YKHttpHelper

    desc "start", "start ykcitool service"
    def start()
      self.start_execute(options)
    end

    desc "stop", "stop ykcitool service"
    def stop()
      self.stop_execute(options)
    end

    no_commands do
      def start_execute(options)
        puts("start service execute")
        YKHttpModule::YKHttpHelper.startService(8088)
      end

      def stop_execute(options)
        puts("stop service execute")
        YKHttpModule::YKHttpHelper.stopService
      end
    end
  end
end