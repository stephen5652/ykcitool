require 'actions/YKFastlaneExecute'
require 'thor'
require 'openssl'

module YKFastlane
  class Certificate < YKFastlane::SubCommandBase

    desc "sync_apple_profile", "sync and install mobile provision file from apple developer service"
    option :user_name, :require => true, :type => :string, :aliases => :u, :desc => 'apple account'
    option :password, :require => true, :type => :string, :aliases => :p, :desc => 'apple account password'
    option :workspace, :require => false, :type => :string, :aliases => :w, :desc => 'p12 password'
    option :bundle_ids, :require => false, :type => :string, :aliases => :b, :desc => "bundle identifier arr, separate by \",\" once more than one"

    def sync_apple_profile()
      puts "options:#{options}"
      code = YKFastlaneExecute.executeFastlaneLane("sync_apple_profile", options)
      exit! code
    end

    desc "update_cer", "edit certificate & profile for project schem or target"
    option :cer_password, :require => true, :type => :string, :aliases => :p, :desc => 'p12 password'
    option :cer_path, :require => true, :type => :string, :aliases => :c, :desc => 'p12 path'

    def update_cer()
      puts "options:#{options}"

      para = {}
      para[:cer_path] = File.expand_path(options[:cer_path]) unless options[:cer_path]
      para[:password] = options[:cer_password]

      code = YKFastlaneExecute.executeFastlaneLane("update_certificate_p12", para)
      exit! code
    end

    desc "sync_cer", "sync certificate & profile git, and will overwrite the existed files once pass the remote_url"
    option :remote_url, :require => false, :type => :string, :aliases => :r, :desc => 'git remote url'

    def sync_cer()
      puts "#{method(:sync_cer)}--options:#{options}"
      code = YKFastlaneExecute.executeFastlaneLane("sync_certificate_profile", options)
      exit! code
    end

    desc "list_details", "list certificate details"

    def list_details()
      puts("certificate list_details")
      code = YKFastlaneExecute.executeFastlaneLane("list_profile_certificate_config", options)
      exit! code
    end

  end
end