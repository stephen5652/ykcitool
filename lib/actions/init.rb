require 'git'
require_relative 'YKFastlaneExecute'

module YKFastlane
  class Init < YKFastlane::SubCommandBase
    desc "script", "init config"
    option :remote, :type => :string, :desc => "fastlane 文件仓库地址"

    def script()
      if options[:remote].blank?
        puts "no remote, work failed"
        exit false
      end

      puts "init config"
      c_path = Helper::YKCONFIG_PATH
      if File.exist?(c_path) == false
        puts "no file, so we create it:#{c_path}"
        File.new(c_path, 'w+')
      end

      p = Helper::YKFastlne_SCRIPT_PATH
      if Dir.exist?(p)
        puts "directory exist, so we delete it:#{p}"
        FileUtils.remove_dir(p, true)
      end

      Git::clone('https://github.com/stephen5652/ykfastlane_scrip.git', p, verbose: true)

      Dir.chdir(p) do
        system("bundle install --verbose")
      end

    end
  end
end
