require 'ykfastlane/tools'
require 'ykfastlane/version'
require 'actions/ios_certificate/cerHelper'

module YKFastlane
  module ProfileTools
    include YKFastlane::Tools
    include YKFastlane::CerHelper
    require 'openssl'

    def analysisProfile(path)
      asn1 = OpenSSL::ASN1.decode_all(File.binread(path))
      plist = asn1[0].value[1].value[0].value[2].value[1].value[0].value
      plist_content = Plist.parse_xml(plist)
      puts "profile_info:#{plist_content}"
      return plist_content
    end

  end
end

