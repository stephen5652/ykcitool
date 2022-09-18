require "actions/YKFastlaneExecute"
module YKFastlane

  class Archive < YKFastlane::SubCommandBase
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

    desc "tf", "archive ios project and upload to test flight, will send failed message to enterprise robot \'#{Helper::YKWECHAT_ROBOT_TOKEN}\'"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :apple_account, :type => :string, :aliases => :a, :required => true, :desc => 'apple account'
    option :password, :type => :string, :aliases => :p, :required => true, :desc => 'App 专用的密码, 参考网站\'https://appleid.apple.com/account/manage\''
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    def tf()
      puts "archive_test_flight"
      options[:export] = 'app-store'
      optoins[:note] = 'Test Flight Release'

      code = YKFastlaneExecute.executeFastlaneLane("archive_pgyer", options)
      exit(code)
    end

  end
end