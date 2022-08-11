module YKFastlane
  module Helper
    '''脚本当前工作路径'''
    YKRUNING_PATH = File.expand_path(Dir.pwd)
    '''fastlane脚本放置路径'''
    YKFastlne_SCRIPT_PATH = File.expand_path(File.join(Dir.home, '.ykfastlane_config', 'ykfastlane_script'))
    '''配置文件放置路'''
    YKCONFIG_PATH = File.expand_path(File.join(Dir.home, '.ykfastlane_config/evnConfig.yml'))
  end
end