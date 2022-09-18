require 'yaml'
require 'json'
require 'ykfastlane/tools'
require 'ykfastlane/version'
module YKFastlane
  module Helper
    include YKFastlane::Tools
    '' '脚本当前工作路径' ''
    YKRUNING_PATH = File.expand_path(Dir.pwd)
    '' 'fastlane脚本放置路径' ''
    YKFastlne_SCRIPT_PATH = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH, 'ykfastlane_script'))
    '' '配置文件放置路径' ''
    YKCONFIG_PATH = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH,'evnConfig.yml'))

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
    YKWECHAT_ROBOT_TOKEN = self.load_config_value(Helper::K_wx_access_token)

  end
end