require "actions/YKFastlaneExecute"
require 'ykfastlane/version'
require 'ykfastlane/tools'
require 'ykfastlane/helper'
require 'actions/archiveHelper'
module YKFastlane

  class Archive < YKFastlane::SubCommandBase
    include YKFastlane::ArchiveHelper

    desc "display_product_path", "display archive output path"

    def display_product_path()
      YKFastlane::Tools.UI(YKARCHIVE_PRODUCT_PATH)
    end

    no_commands {
      def platform_edit_user_execute(options)
        puts("#{method(:platform_edit_user_execute)}:#{options}")
        if options[:pgyer_user].blank? == false && options[:pgyer_api].blank? == false # pgyer
          pgyerinfo = {
            K_archiveEnv_pgyer_api => options[:pgyer_api],
            K_archiveEnv_pgyer_user => options[:pgyer_user]
          }
          self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_pgyer, pgyerinfo)
          puts "archive update pgyer info success"
        end

        if options[:fir_api_token].blank? == false #fir
          fir_info = {
            K_archiveEnv_firApiToken => options[:fir_api_token]
          }
          self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_fir, fir_info)
          puts "archive update fir info success"
        end

        if options[:apple_password].blank? == false && options[:apple_password].blank? == false # tf
          tf_info = {
            K_archiveEnv_tf_account => options[:apple_account],
            K_archiveEnv_tf_password => options[:apple_password]
          }
          self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_tf, tf_info)
          puts "archive update tf info success"
        end
      end
    }

    desc "upload_tf", "upload ipa to test flight, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :ipa, :required => true, :type => :string, :aliases => :i, :desc => 'scheme name'
    option :user_name, :type => :string, :aliases => :u, :desc => 'apple id, 如果不传递，则使用env配置的'
    option :pass_word, :type => :string, :aliases => :p, :desc => 'apple id 专属app密钥, 如果不传递，则使用env配置的 配置链接: https://appleid.apple.com/account/manage'
    option :wxwork_access_token, :type => :string, :aliases => :t, :desc => '微信机器人token， 用以通知到相关业务群，如果没有， 则会使用配置中的机器人， 如果依旧没有， 则不通知企业微信，但是业务依旧成功'
    option :note, :type => :string, :aliases => :n, :desc => '通知信息，用以通知相关业务群，如果没有，业务依旧成功'

    def upload_tf()
      puts "upload_tf"
      if options[:user_name].blank? || options[:pass_word].blank?
        apple_info = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_tf)
        options.update(apple_dict)
      end

      code = YKFastlaneExecute.executeFastlaneLane("upload_ipa_to_tf", options)
      exit(code) unless code == 0
    end

    desc "tf", "archive ios project and upload to TF, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :user_name, :type => :string, :aliases => :u, :desc => 'apple id, 如果不传递，则使用env配置的'
    option :pass_word, :type => :string, :aliases => :p, :desc => 'apple id 专属app密钥, 如果不传递，则使用env配置的 配置链接: https://appleid.apple.com/account/manage'

    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段, 如果没有，则使用env中配置的机器人'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'

    def tf()
      puts "archive_tf"
      if options[:user_name].blank? || options[:pass_word].blank?
        apple_dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_tf)
        if apple_dict != nil && apple_dict.blank?() == false
          options.update(apple_dict)
        end
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_tf", options)
      exit(code) unless code == 0
    end

    desc "pgyer", "archive ios project and upload to pgyer, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :pgyer_api, :type => :string, :aliases => :a, :desc => '蒲公英平台的api key; 如果不传，会使用全局配置的 api key'
    option :pgyer_user, :type => :string, :aliases => :u, :desc => '蒲公英平台的user key; 如果不传，会使用全局配置的 user key'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段, 如果没有，则使用env中配置的机器人'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, app-store, ad-hoc, enterprise 默认为enterprise'

    def pgyer()
      puts "archive_pgyer"

      if options[:pgyer_user].blank? || options[:pgyer_api].blank?
        dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_pgyer)
        options.update(dict)
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_pgyer", options)
      exit(code) unless code == 0
    end

    desc "fir", "archive ios project and upload to fir, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :fir_api_token, :type => :string, :aliases => :f, :desc => 'Fir平台api token'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段, 如果没有，则使用env中配置的机器人'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, app-store, ad-hoc, enterprise 默认为enterprise'

    def fir()
      puts "archive_fir"
      if options[:fir_api_token].blank?
        dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_fir)
        options.update(dict)
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_fir", options)
      exit(code) unless code == 0
    end

    desc "clean_product_dir", "clean product path"
    def clean_product_dir()
      YKFastlaneExecute.executeFastlaneLane("clean_product_directory", options)
    end

    no_commands do
      def list_platform_user_execute()
        self.list_user_map()
      end

      def list_profiles_execute()
        code = YKFastlaneExecute.executeFastlaneLane("list_profile_configs", options)
        exit(code) unless code == 0
      end
    end

  end
end