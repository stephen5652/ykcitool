require 'git'
require 'yaml'
require 'json'

require 'actions/YKFastlaneExecute'
require 'actions/archiveHelper'

module YKFastlane
  class Init < YKFastlane::SubCommandBase
    include Helper

    desc "execute_configs", "execute configs that user defines"

    option :all, :aliases => :a, :type => :boolean, :require => false, :desc => "execute all configs"
    option :script, :aliases => :s, :type => :boolean, :require => false, :desc => "execute script config"
    option :profile, :aliases => :p, :type => :boolean, :require => false, :desc => "execute profile config"

    def execute_configs()
      puts("options:#{options}")
      self.execute_config_execute(options)
    end

    desc "edit_configs", "update all configurations"
    long_desc <<-LONGDESC
    本指令集只是一个门户指令，核心打包功能是通过调用fastlane脚本实现的。\n
    需要配置:\n 
    1. 配置fastlane脚本的远程仓库;\n
    2. 配置任务失败时候的反馈企业微信机器人 企业微信机器人配置: \033[0;32m https://developer.work.weixin.qq.com/document/path/91770 \e[0m\n
    3. p12 与 profile 的托管仓库\n
    4. fir, pgyer, tf 的账号口令\n
    LONGDESC

    option :fastfile_remote, :aliases => :l, :type => :string, :desc => "fastlane 文件的 git remote, 可用参数：#{Helper.default_fast_file_remote()}"

    option :wx_access_token, :aliases => :t, :type => :string, :desc => "enterprise wechat robot token"

    option :profile_remote_url, :aliases => :r, :require => false, :type => :string, :desc => "profile & certificate git remote url, example:#{YKFastlane::Helper.default_certificate_git_remote}"

    option :pgyer_user, :aliases => :u, :type => :string, :required => false, :desc => 'pgyer 平台 user'
    option :pgyer_api, :aliases => :a, :type => :string, :required => false, :desc => 'pgyer 平台 api, 配置链接: \033[0;32m https://appleid.apple.com/account/manage \e[0m'

    option :apple_account, :aliases => :c, :type => :string, :required => false, :desc => 'apple id'
    option :apple_password, :aliases => :p, :type => :string, :required => false, :desc => 'apple id 专属app密钥, 配置链接: \033[0;32m https://appleid.apple.com/account/manage \e[0m'

    option :fir_api_token, :aliases => :f, :type => :string, :required => false, :desc => 'fir 平台 api token'

    def edit_configs()
      require 'actions/certificate'
      require 'actions/archive'
      puts("all_config:#{options}")

      YKFastlane::Init.new().config_execute(options)
      YKFastlane::Archive.new().platform_edit_user_execute(options)
      YKFastlane::Certificate.new().sync_git_execute(options) unless options[:profile_remote_url].blank?
    end

    desc 'define_fast_execute_path', "指定fastlane文件的路径，此处是为了调试fastlane脚本"
    option :debug_flag, :aliases => :d, :type => :string, :require => true, :desc => "运行调试脚本的开关, 1:运行调试脚本， 其他:运行默认脚本"
    option :fastfile_path, :aliases => :e, :type => :string, :desc => "运行的fastlane 文件的路径，此处是为了调试"

    def define_fast_execute_path()
      Helper.update_config("debug flag", Helper::K_YK_CONFIG_FASTLANE_DEBUG, options[:debug_flag] ? options[:debug_flag] : 0)
      Helper.update_config("execute path", Helper::K_YK_CONFIG_FASTLANE_SCRIPT, options[:fastfile_path].blank? ? "" : options[:fastfile_path])
    end

    desc "list_all_configs", "print the env config file: #{Helper::YKCONFIG_PATH}"

    def list_all_configs()
      require 'actions/certificate'
      require 'actions/archive'

      YKFastlane::Certificate.new().list_details_execute()

      YKFastlane::Archive.new().list_platform_user_execute()
      Helper.display_config_yml
      YKFastlane::Archive.new().list_profiles_execute()
    end

    no_commands {
      def execute_config_execute(options)
        require 'actions/certificate'

        if options[:all] == true
          self.sync_script_execute({})
          YKFastlane::Certificate.new().sync_git_execute({})
        else
          if options[:script] == true
            self.sync_script_execute({})
          end
          if options[:profile] == true
            YKFastlane::Certificate.new().sync_git_execute({})
          end
        end
      end

      def sync_script_execute(options)
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

        if File.exist?(File.dirname(p)) == false
          FileUtils.mkdir_p(File.dirname(p))
        end
        FileUtils.mv(p_temp, p, force: true, verbose: true)

        Dir.chdir(p) do
          system("bundle install --verbose")
        end
        return 0
      end

      def config_execute(options)
        puts("#{method(:config_execute)}:#{options}")

        if options[:fastfile_remote].blank? == false
          Helper.update_config('', Helper::K_fastfile_remote, options[:fastfile_remote]) unless options[:fastfile_remote].blank?
          self.sync_script_execute({})
        end

        Helper.update_config('', Helper::K_wx_access_token, options[:wx_access_token]) unless options[:wx_access_token].blank?
        YKFastlane::ArchiveHelper.update_archive_map(Helper::K_wx_access_token, options[:wx_access_token]) unless options[:wx_access_token].blank?
        Helper.display_config_yml
      end
    }

  end

end
