require "actions/YKFastlaneExecute"
require 'ykfastlane/version'
require 'ykfastlane/tools'
module YKFastlane

  module ArchiveHelper
    YKARCHIVE_ENV_PATH = File.join(YKFastlane::YKFASTLANE_ENV_PATH, 'archive_config.yml')

    def load_user_map(scheme_name)
      dict = YKFastlane::Tools.load_yml_value(YKARCHIVE_ENV_PATH, scheme_name)
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

    desc "tf", "archive ios project and upload to TF, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :user_name, :type => :string, :aliases => :u, :required => true, :desc => 'apple id'
    option :pass_word, :type => :string, :aliases => :p, :required => true, :desc => 'apple id 专属app密钥, 配置链接: https://appleid.apple.com/account/manage'

    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    def tf()
      puts "archive_tf"
      if options[:user_name].blank? || options[:pass_word].blank?
        apple_dict = self.load_user_map(options[:scheme])
        if apple_dict != nil
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