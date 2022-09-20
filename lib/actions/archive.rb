require "actions/YKFastlaneExecute"
require 'ykfastlane/version'
require 'ykfastlane/tools'
module YKFastlane

  module ArchiveHelper
    YKARCHIVE_ENV_PATH = File.join(YKFastlane::YKFASTLANE_ENV_PATH, 'archive_config.yml')

    def load_user_map()
      dict = YKFastlane::Tools.load_yml(YKARCHIVE_ENV_PATH)
    end

    def update_user_map(user_name, pass_word)
      YKFastlane::Tools.update_yml("", YKARCHIVE_ENV_PATH, :user_name, user_name)
      YKFastlane::Tools.update_yml("", YKARCHIVE_ENV_PATH, :pass_word, pass_word)
    end

    def list_user_map()
      YKFastlane::Tools.display_yml(YKARCHIVE_ENV_PATH)
    end
  end

  class Archive < YKFastlane::SubCommandBase
    include YKFastlane::ArchiveHelper

    desc "fire", "archive ios project and upload to fire, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :fir_api_token, :type => :string, :aliases => :f, :required => true, :desc => 'Fir平台api token'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, 包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def fire()
      puts "archive_fire"
      code = YKFastlaneExecute.executeFastlaneLane("archive_fire", options)
      exit(code)
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

      self.update_user_map(options[:user_name], options[:pass_word])
      puts "archive tf_edit_user success"
    end

    desc "tf_list_user", "display the tf user map"

    def tf_list_user()
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
        apple_dict = self.load_user_map()
        if apple_dict != nil && apple_dict.blank?() == false
          options[:user_name] = apple_dict[:user_name]
          options[:pass_word] = apple_dict[:pass_word]
        end
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

    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'

    def tf()
      puts "archive_tf"
      if options[:user_name].blank? || options[:pass_word].blank?
        apple_dict = self.load_user_map()
        if apple_dict != nil && apple_dict.blank?() == false
          options[:user_name] = apple_dict[:user_name]
          options[:pass_word] = apple_dict[:pass_word]
        end
      end

      code = YKFastlaneExecute.executeFastlaneLane("archive_tf", options)
      exit(code)
    end

    desc "pgyer", "archive ios project and upload to pgyer, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :pgyer_api, :type => :string, :aliases => :a, :required => true, :desc => '蒲公英平台的api key'
    option :pgyer_user, :type => :string, :aliases => :u, :required => true, :desc => '蒲公英平台的user key'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def pgyer()
      puts "archive_pgyer"
      code = YKFastlaneExecute.executeFastlaneLane("archive_pgyer", options)
      exit(code)
    end

  end
end