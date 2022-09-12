require 'ykfastlane/version'
module YKFastlane
  module CerHelper
    p0 = 'http://gitlab.'
    p1 = 'ye'
    p2 = 'a'
    p3 = 'hk'
    p4 = 'a.com'
    p5 = '/App/iOS/certificates/YKCertificateProfiles.git'

    CER_GIT_DEFAULT_REPOSITORY = "#{p0}#{p1}#{p2}#{p3}#{p4}#{p5}"

    CER_CONFIG_DIR = File.expand_path(File.join(YKFastlane::YKFASTLANE_ENV_PATH, "apple_certificates"))
    CER_CONFIG_FILE = File.expand_path(File.join(CER_CONFIG_DIR, "cer_env_info.yml"))

    CER_CONFIG_DETAIL_DIR = File.expand_path(File.join(CER_CONFIG_DIR, "certificateProfiles"))
    CER_CONFIG_DETAIL_DIR_P12 = File.join(CER_CONFIG_DETAIL_DIR, "certificate_files")
    CER_CONFIG_DETAIL_DIR_PROFILE = File.join(CER_CONFIG_DETAIL_DIR, "profile_files")

    CER_CONFIG_DETAIL_MAP = File.expand_path(File.join(CER_CONFIG_DETAIL_DIR, "cer_map.yml"))


    '' ' 配置文件key-cer_detail_remote' ''
    K_CER_DETAIL_REMOTE = "cer_detail_remote"
    K_CER_ENCRYPT_PASSWORD = "cer_encrypt_key"

    '' ' 证书明细文件key-p12_name' ''
    K_detail_file_name = :file_name

    '' ' 证书明细文件key-p12_password' ''
    K_detail_file_password = :p12_password

    '' ' 证书明细文件key-pro_name' ''
    K_detail_pro_name = "pro_name"

    '' ' 证书明细文件key-pro_type' ''
    K_detail_pro_type = "cer_pro_type"

    '' ' 证书明细文件key-pro_teamId' ''
    K_detail_pro_teamId = "pro_teamID"

    '' ' 证书明细文件key-pro_bundleID' ''
    K_detail_pro_bundleID = "pro_bundleID"

    require 'ykfastlane/tools'
    include YKFastlane::Tools

    def self.update_detail_map(dict, dict_key, file_path, destDir, update_msg)
      YKFastlane::Tools.git_pull(CerHelper::CER_CONFIG_DETAIL_DIR)
      if File.exist?(CerHelper::CER_CONFIG_DETAIL_DIR) == false
        # certificate 配置未下载，需要去下载
        clone_result = YKFastlane::Tools.clone_git_repository(remote, temp_path)
        exit clone_result if clone_result != 0
      end

      file_name = File.basename(file_path)
      dest_path = File.join(destDir, file_name)
      FileUtils.mkdir(destDir) unless File.exist?(destDir)
      puts "copy:#{file_path}"
      puts "dest: #{dest_path}"
      FileUtils.cp_r(file_path, dest_path, remove_destination: true)

      map = YKFastlane::Tools.load_yml(CerHelper::CER_CONFIG_DETAIL_MAP)
      dict[CerHelper::K_detail_file_name] = file_name
      if map[dict_key].blank?
        map[dict_key] = {dict[CerHelper::K_detail_file_name]=> dict}
      else
        cer_map = map[dict_key]
        cer_map[dict[CerHelper::K_detail_file_name]] = dict
        map[dict_key] = cer_map
      end

      YKFastlane::Tools.over_write_yml_dict(CerHelper::CER_CONFIG_DETAIL_MAP, map)

      YKFastlane::Tools.git_commit(CerHelper::CER_CONFIG_DETAIL_DIR, update_msg)
    end
  end
end
