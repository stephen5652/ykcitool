require 'ykfastlane/tools'
require 'ykfastlane/version'
require 'actions/ios_certificate/cerHelper'

module YKFastlane
  module CerTools
    include YKFastlane::Tools
    include YKFastlane::CerHelper
    require "openssl"
    require 'security'
    require 'open3'

    def self.display_cer_env()
      YKFastlane::Tools.display_yml(CerHelper::CER_CONFIG_FILE)
    end

    def self.load_cer_env(key)
      YKFastlane::Tools.load_yml_value(CerHelper::CER_CONFIG_FILE, key)
    end

    def self.update_cer_env(question, key, value)
      YKFastlane::Tools.update_yml(question, CerHelper::CER_CONFIG_FILE, key, value)
    end

    def self.display_cer_map()
      YKFastlane::Tools.display_yml(CerHelper::CER_CONFIG_DETAIL_MAP)
    end

    def self.load_cer_map(key)
      YKFastlane::Tools.load_yml_value(CerHelper::CER_CONFIG_DETAIL_MAP, key)
    end

    def self.analysis_p12(cer_path, cer_pass)
      p12 = OpenSSL::PKCS12.new(File.read(cer_path), cer_pass)
      cer = p12.certificate # OpenSSL::X509::Certificate
      arr = cer.subject.to_a # OpenSSL::X509::Name

      uid = arr.select { |name, _, _| name == 'UID' }.first[1]
      cn = arr.select { |name, _, _| name == 'CN' }.first[1]
      ou = arr.select { |name, _, _| name == 'OU' }.first[1]
      o = arr.select { |name, _, _| name == 'O' }.first[1]
      c = arr.select { |name, _, _| name == 'C' }.first[1]

      result = {
        :c => c,
        :o => o,
        :ou => ou,
        :cn => cn,
        :uid => uid,

      }
      result
    end

    def install_cers(map)
      map.each do |key, info|
        file_path = File.join(CerHelper::CER_CONFIG_DETAIL_DIR_P12, info[CerHelper::K_detail_file_name])
        password = info[CerHelper::K_detail_file_password]

        password_part = " -P #{password}"
        command = "security import #{file_path} -k #{CerHelper.keychain_path("login")}"
        command << password_part
        command << " -T /usr/bin/codesign" # to not be asked for permission when running a tool like `gym` (before Sierra)
        command << " -T /usr/bin/security"
        command << " -T /usr/bin/productbuild" # to not be asked for permission when using an installer cert for macOS
        command << " -T /usr/bin/productsign"  # to not be asked for permission when using an installer cert for macOS

        sensitive_command = command.gsub(password_part, " -P ********")
        YKFastlane::Tools.UI(sensitive_command)
        Open3.popen3(command) do |stdin, stdout, stderr, thrd|
          YKFastlane::Tools.UI(stdout.read.to_s)

          # Set partition list only if success since it can be a time consuming process if a lot of keys are installed
          if thrd.value.success?
            YKFastlane::Tools.UI("install one p12 success:#{file_path}")
          else
            # Output verbose if file is already installed since not an error otherwise we will show the whole error
            err = stderr.read.to_s.strip
            if err.include?("SecKeychainItemImport") && err.include?("The specified item already exists in the keychain")
              YKFastlane::Tools.UI("'#{File.basename(path)}' is already installed on this machine")
            else
              YKFastlane::Tools.UI("error:#{err}")
            end
          end
        end

      end

    end

  end
end
