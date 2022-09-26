require 'ykfastlane/tools'
require 'ykfastlane/version'
require 'actions/ios_certificate/cerHelper'

module YKFastlane
  module ProfileTools
    include YKFastlane::Tools
    include YKFastlane::CerHelper
    require 'openssl'
    require 'plist'

    def analysisProfile(path)
      asn1 = OpenSSL::ASN1.decode_all(File.binread(path))
      plist = asn1[0].value[1].value[0].value[2].value[1].value[0].value
      plist_content = Plist.parse_xml(plist)
      return plist_content
    end

    # @return [String] The UUID of the given provisioning profile
    def uuid(path, keychain_path = nil)
      dict = analysisProfile(path)
      dict["UUID"]
    end

    def profile_extension(path, keychain_path = nil)
      ".mobileprovision"
    end

    def profiles_path
      path = File.expand_path("~") + "/Library/MobileDevice/Provisioning Profiles/"
      # If the directory doesn't exist, create it first
      unless File.directory?(path)
        FileUtils.mkdir_p(path)
      end

      return path
    end

    def profile_filename(path, keychain_path = nil)
      basename = uuid(path, keychain_path)
      basename + profile_extension(path, keychain_path)
    end

    # Installs a provisioning profile for Xcode to use
    def install(path, keychain_path = nil)
      YKFastlane::Tools.UI("Installing provisioning profile:#{path}")
      destination = File.join(profiles_path, profile_filename(path, keychain_path))
      YKFastlane::Tools.UI("destination:#{destination}")
      if path != destination
        # copy to Xcode provisioning profile directory
        FileUtils.copy(path, destination)
        unless File.exist?(destination)
          YKFastlane::Tools.UI("Failed installation of provisioning profile at location: '#{destination}'")
        end
      end

      destination
    end

    def install_profiles(map)
      map.each do |key, info|
        file_path = File.join(CerHelper::CER_CONFIG_DETAIL_DIR_PROFILE, info[CerHelper::K_detail_file_name])
        install(file_path, CerHelper.keychain_path("login"))
      end
    end

  end
end

