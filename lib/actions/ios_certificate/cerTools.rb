require 'ykfastlane/tools'
require 'ykfastlane/version'
require 'actions/ios_certificate/cerHelper'

module YKFastlane
  module CerTools
    include YKFastlane::Tools
    include YKFastlane::CerHelper
    require "openssl"

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
      puts "certificate_info:#{result}"
      result
    end

  end
end
