require 'actions/YKFastlaneExecute'
require 'ykfastlane/helper'
require 'thor'
require 'openssl'

module YKFastlane
  class Certificate < YKFastlane::SubCommandBase

    desc "sync_apple_profile", "sync and install mobile provision file from apple developer service"
    option :user_name, :require => true, :type => :string, :aliases => :u, :desc => 'apple account'
    option :password, :require => true, :type => :string, :aliases => :p, :desc => 'apple account password'
    option :workspace, :require => false, :type => :string, :aliases => :w, :desc => 'p12 password'
    option :bundle_ids, :require => false, :type => :array, :aliases => :b, :desc => "bundle identifier arr, separate by \" \" once more than one, exaple: 123 456 234"

    def sync_apple_profile()
      puts "options:#{options}"
      arr = options[:bundle_ids]
      if arr != nil && arr.count > 0
        str = arr.join(",")
        options[:bundle_ids] = str
      end

      if options[:workspace].blank? == false
        Dir.chdir(Dir.pwd) do
          options[:workspace] = File.expand_path(options[:workspace])
        end
      end

      puts "options_formatter:#{options}"
      code = YKFastlaneExecute.executeFastlaneLane("sync_apple_profile", options)
      exit! code
    end

    desc "update_profile", "Update one profile"
    option :profile_path, :require => true, :type => :array, :aliases => :p, :desc => 'profile path'

    def update_profile()
      result_arr = []
      arr = options[:profile_path]
      if arr != nil && arr.count > 0
        Dir.chdir(Dir.pwd) do
          arr.each do |one|
            path = File.expand_path(one)
            result_arr << path
          end
        end
      end

      str = result_arr.join(",")
      options[:profile_path] = str unless str.blank?
      puts "options:#{options}"
      code = YKFastlaneExecute.executeFastlaneLane("update_profiles", options)
      exit! code
    end

    desc "update_cer", "edit certificate & profile for project schem or target"
    option :cer_password, :require => true, :type => :string, :aliases => :p, :desc => 'p12 password'
    option :cer_path, :require => true, :type => :string, :aliases => :c, :desc => 'p12 path'

    def update_cer()
      puts "options:#{options}"

      para = {}
      Dir.chdir(Dir.pwd) do
        para[:cer_path] = File.expand_path(options[:cer_path]) unless options[:cer_path].blank?
      end

      para[:password] = options[:cer_password]

      code = YKFastlaneExecute.executeFastlaneLane("update_certificate_p12", para)
      exit! code
    end

    desc "sync_git", "sync certificate & profile git, and will overwrite the existed files once pass the remote_url"
    option :remote_url, :require => false, :type => :string, :aliases => :r, :desc => "git remote url, example:#{YKFastlane::Helper.default_certificate_git_remote}"

    def sync_git()
      puts "#{method(:sync_git)}--options:#{options}"
      self.sync_git_execute(options)
    end

    no_commands {
      def sync_git_execute(options)
        puts "#{method(:sync_git_execute)}--options:#{options}"
        code = YKFastlaneExecute.executeFastlaneLane("sync_certificate_profile", options)
        exit! code
      end
    }

    desc "list_details", "list certificate details"

    def list_details()
      puts("certificate list_details")
      code = YKFastlaneExecute.executeFastlaneLane("list_profile_certificate_config", options)
      exit! code
    end

  end
end