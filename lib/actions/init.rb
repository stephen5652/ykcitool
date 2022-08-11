require_relative 'YKFastlaneExecute'

module YKFastlane
  class Init < YKFastlane::SubCommandBase
    desc "initconfig", "init config"
    option :wxtoken, :desc => "配置脚手架，用以完成基础参数的配置"

    def config()
      puts "init config"
      c_path = Helper::YKCONFIG_PATH
      if File.exist?(c_path) == false
        puts "no file:#{c_path}"
        File.new(c_path, 'w+')
      else
        puts "file existed: #{c_path}"
      end
    end
  end
end
