require 'ykcitool/helper'
require 'actions/init'

module YKHttpModule
  require 'webrick'

  require 'ykcitool/version'
  require 'HttpService/YKHttpServerConst'

  class YKHttpServerLet < WEBrick::HTTPServlet::AbstractServlet
    require 'HttpService/handlers/yk_http_handlers'

    def do_GET (request, response)
      #WEBrick::HTTPRequest WEBrick::HTTPResponse
      path = request.path
      if path == YKHttpModule::HTGitDiff.path
        YKHttpModule::HTGitDiff.new(request, response).execute

      else
        YKHttpModule::YKHttpHandlerBase.failed(request, response, YKHttpModule::YKHttpHandlerBase::YKHTTP_CODE_PATHERROR)
      end

    end

    def do_POST(request, response)
      path = request.path
      if path == YKHttpModule::HTGitDiff.path
        YKHttpModule::HTGitDiff.new(request, response).execute

      else
        YKHttpModule::YKHttpHandlerBase.failed(request, response, YKHttpModule::YKHttpHandlerBase::YKHTTP_CODE_PATHERROR)
      end

    end

  end

  module YKHttpHelper

    YKHTTP_LOG_FILE = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH, "http_server", 'log', 'webrick.log'))

    def self.startService(port)
      ## access log
      log_dir = File.dirname(YKHttpHelper::YKHTTP_LOG_FILE)
      if File.exist?(log_dir) == false
        FileUtils.mkdir_p(log_dir)
      end
      logfile = File.open YKHttpHelper::YKHTTP_LOG_FILE, 'a+'
      logfile.sync = true
      log = WEBrick::Log.new(logfile, WEBrick::BasicLog::INFO)
      puts("webrick log file:#{YKHttpHelper::YKHTTP_LOG_FILE}")

      access_log = [
        [logfile, WEBrick::AccessLog::COMMON_LOG_FORMAT],
      # [logfile, WEBrick::AccessLog::REFERER_LOG_FORMAT],
      # [logfile, WEBrick::AccessLog::CLF_TIME_FORMAT],
      # [logfile, WEBrick::AccessLog::AGENT_LOG_FORMAT],
      ]
      server = WEBrick::HTTPServer.new :AccessLog => access_log
      logger = WEBrick::Log.new logfile, :AccessLog => access_log
      server = WEBrick::HTTPServer.new(:Port => 8088, :Logger => log, :AccessLog => access_log)
      puts("should start http service at port:#{port}")
      server.mount "/", YKHttpModule::YKHttpServerLet

      #trap '(exit 130)' INT
      trap("INT") {
        server.shutdown
      }
      # WEBrick::Daemon.start
      YKHttpModule::YKHttpConst.set_cur_server(server)
      server.start

    end

    def self.stopService()
      puts("should stop http service")
    end
  end
end
