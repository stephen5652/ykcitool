require 'git'
require 'yaml'
require 'json'

require 'actions/YKFastlaneExecute'
require 'actions/archiveHelper'

module YKFastlane
  class Init < YKFastlane::SubCommandBase
    include Helper

    desc "sync_script", "sync fast file from the remote"
    long_desc <<-LONGDESC
    同步远端fastlane脚本，此处可以通过参数下载固定的fastlan仓库，也可以使用环境配置的仓库来下载。
    LONGDESC
    option :fastfile_remote, :aliases => :f, :type => :string, :desc => "fastlane 文件仓库地址, 如果未传递，则使用env中配置的，#{Helper::YKCONFIG_PATH}"

    def sync_script()
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

    desc 'config', "update configuration file: #{Helper::YKCONFIG_PATH}"
    long_desc <<-LONGDESC
    本指令集只是一个门户指令，核心打包功能是通过调用fastlane脚本来实现的。
    需要配置： 1.配置fastlane脚本的远程仓库； 2.配置任务失败时候的反馈企业微信机器人, [【企业微信机器人配置】](https://developer.work.weixin.qq.com/document/path/91770)
    LONGDESC
    option :fastfile_remote, :aliases => :f, :type => :string, :desc => "fastlane 文件的git remote, 可用参数：#{Helper.default_fast_file_remote()}"
    option :wx_access_token, :aliases => :t, :type => :string, :desc => "enterprise wechat robot token"

    def config()
      puts "options:#{options}"
      Helper.update_config('', Helper::K_fastfile_remote, options[:fastfile_remote]) unless options[:fastfile_remote].blank?
      Helper.update_config('', Helper::K_wx_access_token, options[:wx_access_token]) unless options[:wx_access_token].blank?
      YKFastlane::ArchiveHelper.update_archive_map(Helper::K_wx_access_token, options[:wx_access_token]) unless options[:wx_access_token].blank?
      Helper.display_config_yml
    end

    desc 'define_fast_execute_path', "指定fastlane文件的路径，此处是为了调试fastlane脚本"
    option :debug_flag, :aliases => :d, :type => :string, :require => true, :desc => "运行调试脚本的开关, 1:运行调试脚本， 其他:运行默认脚本"
    option :fastfile_path, :aliases => :e, :type => :string, :desc => "运行的fastlane 文件的路径，此处是为了调试"

    def define_fast_execute_path()
      Helper.update_config("debug flag", Helper::K_YK_CONFIG_FASTLANE_DEBUG, options[:debug_flag] ? options[:debug_flag] : 0)
      Helper.update_config("execute path", Helper::K_YK_CONFIG_FASTLANE_SCRIPT, options[:fastfile_path].blank? ? "" : options[:fastfile_path])
    end

    desc "list_config", "print the env config file: #{Helper::YKCONFIG_PATH}"

    def list_config()
      Helper.display_config_yml
    end

  end

end
