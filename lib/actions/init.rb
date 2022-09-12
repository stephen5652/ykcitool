require 'git'
require 'yaml'
require 'json'

require 'actions/YKFastlaneExecute'

module YKFastlane
  class Init < YKFastlane::SubCommandBase
    include Helper

    desc "script", "init fast file from the remote"
    option :fastfile_remote, :aliases => :f, :type => :string, :desc => "fastlane 文件仓库地址, 如果未传递，则使用env中配置的，#{Helper::YKCONFIG_PATH}"

    def script()
      fastfile_remote = options[:fastfile_remote].blank? ? Helper::load_config_value(Helper::K_fastfile_remote) : options[:fastfile_remote]

      if fastfile_remote.blank?
        puts "no remote, work failed"
        exit false
      end

      p = Helper::YKFastlne_SCRIPT_PATH
      p_temp = p + "_temp"
      FileUtils.remove_dir(p_temp, force: true)

      cloneResult = YKFastlane::Tools.clone_git_repository(fastfile_remote, p_temp)
      if cloneResult != 0
        exit cloneResult
      end

      if Dir.exist?(p)
        puts "directory exist, so we delete it:#{p}"
        FileUtils.remove_dir(p, true)
      end
      FileUtils.mv(p_temp, p, force: true, verbose: true)

      Dir.chdir(p) do
        system("bundle install --verbose")
      end
      return 0
    end

    desc 'config', "update configuration file: #{Helper::YKCONFIG_PATH}"
    option :fastfile_remote, :aliases => :f, :type => :string, :desc => "fastlane 文件的git remote, 可用参数：#{Helper.default_fast_file_remote()}"
    option :wx_token, :aliases => :t, :type => :string, :desc => "enterprise wechat robot token"

    def config()
      puts "options:#{options}"
      Helper.update_config('', Helper::K_fastfile_remote, options[:fastfile_remote]) unless options[:fastfile_remote].blank?
      Helper.update_config('', Helper::K_wx_access_token, options[:wx_token]) unless options[:wx_token].blank?
      Helper.display_config_yml
    end

    desc "list_config", "print the env config file: #{Helper::YKCONFIG_PATH}"

    def list_config()
      Helper.display_config_yml
    end

  end

end
