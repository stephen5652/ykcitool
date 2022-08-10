# frozen_string_literal: true

require_relative "ykfastlane/version"

require 'thor'

require 'actions/YKFastlaneExecute'
module Ykfastlane
  class Cmd < Thor
    def self.exit_on_failure?
      true
    end

    desc "initconfig", "init config"
    option :wxtoken, :desc => "微信机器人token， 用于统一上报错误"

    def initconfig()
      puts "init config"
    end

    desc "archive_fire", "archive ios project and upload to fire"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :fir_api_token, :type => :string, :aliases => :f, :required => true, :desc => 'Fir平台api token'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, 包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def archive_fire()
      puts "archive_fire"
      code = Ykfastlane::YKFastlaneExecute.executeFastlaneLane("archive_fire", options)
      exit(code)
    end

    desc "lanes", 'list all lanes'

    def lanes()
      puts "lanes"
      code = Ykfastlane::YKFastlaneExecute.executeFastlaneLane("lanes", options)
      exit(code)
    end

    desc "archive_pgyer", "archive ios project and upload to pgyer"
    option :scheme, :required => true, :type => :string, :aliases => :s, :desc => 'scheme name'
    option :pgyer_api, :type => :string, :aliases => :a, :required => true, :desc => '蒲公英平台的api key'
    option :pgyer_user, :type => :string, :aliases => :u, :required => true, :desc => '蒲公英平台的user key'
    option :wxwork_access_token, :type => :string, :aliases => :w, :desc => '企业微信机器人 webhook中的key字段'
    option :note, :type => :string, :aliases => :n, :desc => '测试包发包信息'
    option :xcworkspace, :type => :string, :aliases => :x, :desc => '.xcworkspace 文件相对于指令工作目录的相对路径, 如果.xcworkspace文件在工程根目录，则可以不传递此参数'
    option :cocoapods, :type => :numeric, :aliases => :c, :desc => '是否需要执行pod install, 默认不执行pod install 指令, 1:执行， 非1：不执行'
    option :flutter_directory, :type => :string, :aliases => :d, :desc => '如果有flutter混编, 此参数是 flutter项目的相对路径.'
    option :export, :type => :string, :aliases => :e, :desc => '包的类型, app-store, validation,ad-hoc, package, enterprise, development, developer-id, mac-application, 默认为enterprise'

    def archive_pgyer()
      puts "archive_pgyer"
      code = Ykfastlane::YKFastlaneExecute.executeFastlaneLane("archive_pgyer", options)
      exit(code)
    end

    desc 'github_pod_transfer', '迁移github三方库到移开gitlab.'
    long_desc <<-LONGDESC
    1. 需要在移开gitlab创建一个同名的git仓库.
    2. 尝试迁移所有tag, 当碰到迁移失败的tag的时候，并不会导致整个迁移的失败;
    3. 最终会输出迁移成功的数组和失败的数组
    LONGDESC
    option :orignal_url, :aliases => :o, :required => true, :type => :string, :desc => '原始源码仓库'
    option :ykgitlab_url, :aliases => :d, :required => true, :type => :string, :desc => '迁移的目标仓库'
    option :versions, :aliases => :s, :type => :string, :desc => '迁移的目标版本，多个的时候用空格\' \'隔开， 默认遍历尝试迁移所有的版本，比较耗时'
    option :wxwork_access_token, :aliases => :w, :type => :string, :desc => '用于将任务结果传给企业微信'

    def github_pod_transfer()
      puts "github_pod_transfer"
      code = Ykfastlane::YKFastlaneExecute.executeFastlaneLane("github_pod_transfer", options)
      exit(code)
    end

  end
end
