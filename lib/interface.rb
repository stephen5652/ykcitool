# frozen_string_literal: true

require 'ykfastlane/version'

require 'actions/YKFastlaneExecute'
require 'actions/archive'
require 'actions/pod'
require 'actions/init'

module YKFastlane
  class Interface < Thor
    class_option :verbose, :type => :boolean
    def self.exit_on_failure?
      true
    end

    desc "lanes", 'list all lanes'

    def lanes()
      puts "lanes"
      code = YKFastlane::YKFastlaneExecute.executeFastlaneLane("lanes", options)
      exit(code)
    end

    desc "archive", "archive functions"
    subcommand "archive", YKFastlane::Archive

    desc "pod", "cocoapods functions"
    subcommand "pod", YKFastlane::Pod

    desc "init", "init ykfastlane"
    subcommand "init", YKFastlane::Init
  end
end
