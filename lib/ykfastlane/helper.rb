require 'yaml'
require 'json'
require 'ykfastlane/tools'
require 'ykfastlane/version'
module YKFastlane
  module Helper
    include YKFastlane::Tools
    '' '脚本当前工作路径' ''
    YKRUNING_PATH = File.expand_path(Dir.pwd)
    '' '配置文件放置路径' ''
    YKCONFIG_PATH = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH,'evnConfig.yml'))

    '' 'fastlane脚本放置路径' ''
    YKFastlne_SCRIPT_PATH = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH, 'ykfastlane_script'))

    def self.load_config_yml()
      Tools.load_yml(Helper::YKCONFIG_PATH)
    end

    def self.display_config_yml()
      Tools.display_yml(Helper::YKCONFIG_PATH)
    end

    def self.load_config_value(key)
      Tools.load_yml_value(Helper::YKCONFIG_PATH, key)
    end

    def self.update_config(qustion, key, value)
      Tools.update_yml(qustion, Helper::YKCONFIG_PATH, key, value)
    end

    def self.default_fast_file_remote()
      p1 = "y"
      p2 = 'ea'
      p3 = "h"
      p4 = "ka"

      url1 = "http://gitlab.#{p1}#{p2}#{p3}#{p4}.com/App/iOS/ykfastlane.git"
      url2 = "https://github.com/stephen5652/ykfastlane_scrip.git"
      "" "
      \033[0;32m#{url1}\e[0m or \033[0;32m#{url2}\e[0m
        " ""
    end

    '' ' 配置文件key-fastfile_remote' ''
    K_fastfile_remote = "fastfile_remote"

    '' ' 配置文件key-wx_access_token' ''
    K_wx_access_token = "wx_access_token"

    '' '企业微信CI机器人' ''
    YKWECHAT_ROBOT_TOKEN = Helper.load_config_value(Helper::K_wx_access_token)

    '''fastlane脚本路径'''
    K_YK_CONFIG_FASTLANE_SCRIPT = :fast_file
    '''fastlane debug开关'''
    K_YK_CONFIG_FASTLANE_DEBUG = :fast_file_debug

    def self.fastlane_script
      path = Helper.load_config_value(K_YK_CONFIG_FASTLANE_SCRIPT)
      debug = Helper.load_config_value(K_YK_CONFIG_FASTLANE_DEBUG)
      puts "path:#{path}"
      puts "debug flag[#{debug.class}]:#{debug}"
      if path.blank? || debug.blank? || debug != "1"
        path = YKFastlne_SCRIPT_PATH
      end
      puts "fastlane file path:#{path}"
      path
    end

  end
end