# frozen_string_literal: true

require_relative "ykfastlane/version"

require_relative 'actions/YKFastlaneExecute'
require_relative 'actions/archive'
require_relative 'actions/pod'
require_relative 'actions/init'

module Ykfastlane
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
