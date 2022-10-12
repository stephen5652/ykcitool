# frozen_string_literal: true

require 'ykfastlane/version'

require 'actions/YKFastlaneExecute'
require 'actions/archive'
require 'actions/pod'
require 'actions/init'
require 'actions/certificate'
require 'thor'

module YKFastlane
  class Interface < Thor
    include Thor::Actions
    require_relative 'actions/YKFastlaneExecute'

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

    desc "certificate", "manager ios certificate & profile files"
    subcommand "certificate", YKFastlane::Certificate
  end
end
