require 'ykfastlane/version'
require 'ykfastlane/tools'
require 'ykfastlane/helper'
module YKCitool

  module ArchiveHelper
    YKARCHIVE_PRODUCT_PATH = File.expand_path(File.join(Dir.home, "iosYeahArchive"))

    YKARCHIVE_ENV_PATH = File.join(YKCitool::YKFASTLANE_ENV_PATH, 'archive_config', 'archive_config.yml')

    K_archiveEnv_config_tf = :test_flight
    K_archiveEnv_tf_account = :user_name
    K_archiveEnv_tf_password = :pass_word

    K_archiveEnv_config_fir = :fir
    K_archiveEnv_firApiToken = :fir_api_token

    K_archiveEnv_config_pgyer = :pgyer
    K_archiveEnv_pgyer_user = :pgyer_user
    K_archiveEnv_pgyer_api = :pgyer_api

    def self.update_archive_map(key, value)
      YKCitool::Tools.update_yml("", YKARCHIVE_ENV_PATH, key, value)
    end

    def update_archive_map(key, value)
      YKCitool::Tools.update_yml("", YKARCHIVE_ENV_PATH, key, value)
    end

    def load_archive_config_dict(platform_name)
      dict = YKCitool::Tools.load_yml_value(YKARCHIVE_ENV_PATH, platform_name)
      return dict == nil ? {} : dict
    end

    def list_user_map()
      YKCitool::Tools.display_yml(YKARCHIVE_ENV_PATH)
    end

  end

end
