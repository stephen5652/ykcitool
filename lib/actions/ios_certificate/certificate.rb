require "actions/ios_certificate/cerTools"
require 'actions/ios_certificate/profileTools'
require 'actions/ios_certificate/cerHelper'
require 'actions/YKFastlaneExecute'
require 'thor'
require 'fastlane'
require 'openssl'

module YKFastlane
  class Certificate < YKFastlane::SubCommandBase

    include YKFastlane::Tools
    include YKFastlane::CerHelper
    include YKFastlane::CerTools
    include YKFastlane::ProfileTools

    desc "update_cer", "edit certificate & profile for project schem or target"
    option :cer_password, :require => true, :type => :string, :aliases => :p, :desc => 'p12 password'
    option :cer_path, :require => true, :type => :string, :aliases => :c, :desc => 'p12 path'

    def update_cer()
      puts "options:#{options}"

      cer_path = options[:cer_path]
      cer_pass = options[:cer_password]
      result = YKFastlane::CerTools.analysis_p12(cer_path, cer_pass)
      result[CerHelper::K_detail_file_password] = cer_pass

      cer_name = File.basename(cer_path)
      result = CerHelper.update_detail_map(result, :cer_map, cer_path, CerHelper::CER_CONFIG_DETAIL_DIR_P12, "update certificate:#{cer_name}")
      YKFastlane::Tools.UI("update certificate success:#{cer_name}") unless  result != 0
    end

    desc "update_profile", "edit certificate & profile for project schem or target"
    option :profile_path, :require => true, :type => :string, :aliases => :p, :desc => 'profile path'

    def update_profile()
      puts "options:#{options}"
      YKFastlane::Tools.notify_message_to_enterprise_wechat("no profile", 0) if options[:profile_path].blank?
      path = options[:profile_path]
      dict = self.analysisProfile(path)

      profile_name = File.basename(path)
      result = CerHelper.update_detail_map(dict, :profile_map, path, CerHelper::CER_CONFIG_DETAIL_DIR_PROFILE, "update profile:#{profile_name}")
      YKFastlane::Tools.UI("update profile success:#{profile_name}") unless  result != 0
    end

    desc "sync_cer", "edit certificate & profile for project schem or target"
    def sync_cer()
      puts "#{method(:sync_cer)}--options:#{options}"
      YKFastlane::Tools.git_pull(CerHelper::CER_CONFIG_DETAIL_DIR)
      yml = YKFastlane::Tools.load_yml(CerHelper::CER_CONFIG_DETAIL_MAP)
      cer_map = yml[:cer_map]
      self.install_cers(cer_map)
      profile_map = yml[:profile_map]
      self.install_profiles(profile_map)
    end

    desc "edit_config", "edit certificate & profile git info, you can create your own git repository or used default repository:#{CerHelper::CER_GIT_DEFAULT_REPOSITORY}"
    option :remote, :require => true, :type => :string, :aliases => :r, :desc => 'certificate & profile git remote'
    option :cer_encrypt_password, :require => true, :type => :string, :aliases => :p, :desc => 'certificate encrypt & decrypt password'

    def edit_config()
      puts "options:#{options}"
      encrypt_password = options[:cer_encrypt_password]
      YKFastlane::CerTools.update_cer_env('certificate encrypt password', CerHelper::K_CER_ENCRYPT_PASSWORD, encrypt_password) unless encrypt_password.blank?

      remote = options[:remote]
      remote = CerHelper::CER_GIT_DEFAULT_REPOSITORY unless  remote.blank?
      if remote.blank? == false
        c_path = CerHelper::CER_CONFIG_DETAIL_DIR
        temp_path = c_path
        temp_path = temp_path + "_temp"

        clone_result = YKFastlane::Tools.clone_git_repository(remote, temp_path)
        exit clone_result if clone_result != 0

        YKFastlane::CerTools.update_cer_env('certificate git remote', CerHelper::K_CER_DETAIL_REMOTE, remote)

        if File.exist?(c_path)
          puts "path existed, we should delete it:#{c_path}"
          FileUtils.rm_r(c_path)
        end

        FileUtils.mv(temp_path, c_path, force: true, verbose: true)
        puts "certificate detail path:#{c_path}"
      end
      return 0

    end

    desc "list_config", "list certificate env"

    def list_config()
      YKFastlane::Tools.display_yml(CerTools::CER_CONFIG_FILE)
    end

    desc "list_cers", "list cached certificates and profiles "

    def list_cers()
      YKFastlane::Tools.UI("cached_yml:#{CerTools::CER_CONFIG_DETAIL_MAP}\n")
      YKFastlane::Tools.display_yml(CerTools::CER_CONFIG_DETAIL_MAP)
    end

  end
end