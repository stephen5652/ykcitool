require "actions/YKFastlaneExecute"
require 'ykfastlane/version'
require 'ykfastlane/tools'
module YKFastlane

  module ArchiveHelper
    YKARCHIVE_PRODUCT_PATH = File.expand_path(File.join(Dir.home, "iosYeahArchive"))

    YKARCHIVE_ENV_PATH = File.join(YKFastlane::YKFASTLANE_ENV_PATH, 'archive_config.yml')

    K_archiveEnv_config_tf = :test_flight

    K_archiveEnv_config_fir = :fir
    K_archiveEnv_firApiToken = :fir_api_token

    K_archiveEnv_config_pgyer = :pgyer
    K_archiveEnv_pgyer_user = :pgyer_user
    K_archiveEnv_pgyer_api = :pgyer_api

    def update_archive_map(key, value)
      YKFastlane::Tools.update_yml("", YKARCHIVE_ENV_PATH, key, value)
    end

    def load_archive_config_dict(platform_name)
      dict = YKFastlane::Tools.load_yml_value(YKARCHIVE_ENV_PATH, platform_name)
      return dict == nil ? {} : dict
    end

    def list_user_map()
      YKFastlane::Tools.display_yml(YKARCHIVE_ENV_PATH)
    end
  end

  class Archive < YKFastlane::SubCommandBase
    include YKFastlane::ArchiveHelper

    desc "display_product_path", "display archive output path"

    def display_product_path()
      YKFastlane::Tools.UI(YKARCHIVE_PRODUCT_PATH)
    end

    desc "tf_edit_user", "edit or update tf apple account and password"
    option :user_name, :type => :string, :aliases => :u, :required => true, :desc => 'apple id'
    option :pass_word, :type => :string, :aliases => :p, :required => true, :desc => 'apple id 专属app密钥, 配置链接: https://appleid.apple.com/account/manage'

    def tf_edit_user()
      puts "archive tf_edit_user"
      if options[:user_name].blank? || options[:user_name].blank?
        YKFastlane::Tools.UI("work failed, since no :user_name or :pass_word --parameters:#{options}")
        exit!(1)
      end

      self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_tf, options)
      puts "archive tf_edit_user success"
    end

    desc "fir_edit_user", "edit or update fir api token"
    option :fir_api_token, :type => :string, :aliases => :f, :required => true, :desc => 'fir 平台 api token'

    def fir_edit_user()
      puts "archive fir_edit_user"
      if options[:fir_api_token].blank?
        YKFastlane::Tools.UI("work failed, since no :fir_api_token")
        exit!(1)
      end

      self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_fir, options)
      puts "archive tf_edit_user success"
    end

    desc "pgyer_edit_user", "edit or update pgyer user"
    option :pgyer_user, :type => :string, :aliases => :u, :required => true, :desc => 'pgyer 平台 user'
    option :pgyer_api, :type => :string, :aliases => :a, :required => true, :desc => 'pgyer 平台 api, 配置链接: https://appleid.apple.com/account/manage'

    def pgyer_edit_user()
      puts "archive fir_edit_user"
      if options[:pgyer_user].blank? || options[:pgyer_api].blank?
        YKFastlane::Tools.UI("work failed, since no :pgyer_user or :pgyer_api")
        exit!(1)
      end

      self.update_archive_map(YKFastlane::ArchiveHelper::K_archiveEnv_config_pgyer, options)
      puts "archive tf_edit_user success"
    end

    desc "list_platform_user", "display the ipa bump platform user map"

    def list_platform_user()
      self.list_user_map()
    end

    desc "upload_tf", "upload ipa to test flight, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :ipa, :required => true, :type => :string, :aliases => :i, :desc => 'scheme name'
    option :user_name, :type => :string, :aliases => :u, :desc => 'apple id, 如果不传递，则使用env配置的'
    option :pass_word, :type => :string, :aliases => :p, :desc => 'apple id 专属app密钥, 如果不传递，则使用env配置的 配置链接: https://appleid.apple.com/account/manage'
    option :wxwork_access_token, :type => :string, :aliases => :t, :desc => '微信机器人token， 用以通知到相关业务群，如果没有， 则会使用配置中的机器人， 如果依旧没有， 则不通知企业微信，但是业务依旧成功'
    option :note, :type => :string, :aliases => :n, :desc => '通知信息，用以通知相关业务群，如果没有，业务依旧成功'

    def upload_tf()
      puts "upload_tf"
      if options[:user_name].blank? || options[:pass_word].blank?
        apple_dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_tf)
        options.update(apple_dict)
      end

      if options[:wxwork_access_token].blank?
        wxtoken = YKFastlane::Helper.load_config_value(YKFastlane::Helper::K_wx_access_token)
        options[:wxwork_access_token] = wxtoken unless wxtoken.blank?
      end

      code = YKFastlaneExecute.executeFastlaneLane("upload_ipa_to_tf", options)
      exit(code)
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

      if options[:wxwork_access_token].blank?
        wxtoken = YKFastlane::Helper.load_config_value(YKFastlane::Helper::K_wx_access_token)
        options[:wxwork_access_token] = wxtoken unless wxtoken.blank?
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_tf", options)
      exit(code)
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
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def pgyer()
      puts "archive_pgyer"
      if options[:wxwork_access_token].blank?
        wxtoken = YKFastlane::Helper.load_config_value(YKFastlane::Helper::K_wx_access_token)
        options[:wxwork_access_token] = wxtoken unless wxtoken.blank?
      end

      if options[:pgyer_user].blank? || options[:pgyer_api].blank?
        dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_pgyer)
        options.update(dict)
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_pgyer", options)
      exit(code)
    end

    desc "fir", "archive ios project and upload to fir, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :fir_api_token, :type => :string, :aliases => :f, :desc => 'Fir平台api token'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段, 如果没有，则使用env中配置的机器人'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, 包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def fir()
      puts "archive_fir"
      if options[:wxwork_access_token].blank?
        wxtoken = YKFastlane::Helper.load_config_value(YKFastlane::Helper::K_wx_access_token)
        options[:wxwork_access_token] = wxtoken unless wxtoken.blank?
      end

      if options[:fir_api_token].blank?
        dict = self.load_archive_config_dict(YKFastlane::ArchiveHelper::K_archiveEnv_config_fir)
        options.update(dict)
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_fire", options)
      exit(code)
    end

  end
end