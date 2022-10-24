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
    include YKFastlane::Helper

    class_option :verbose, :type => :boolean
    def self.exit_on_failure?
      true
    end

    # desc "lanes", 'list all lanes'
    #
    # def lanes()
    #   puts "lanes"
    #   code = YKFastlane::YKFastlaneExecute.executeFastlaneLane("lanes", options)
    #   exit(code)
    # end

    desc "archive", "archive functions"
    subcommand "archive", YKFastlane::Archive

    # desc "pod", "cocoapods functions"
    # subcommand "pod", YKFastlane::Pod

    desc "init", "init ykcitool"
    subcommand "init", YKFastlane::Init

    desc "certificate", "manager ios certificate & profile files"
    subcommand "certificate", YKFastlane::Certificate

    desc  "update", "update ykcitool"
    def update()
      require 'actions/YKFastlaneExecute'
      code = YKFastlane::YKFastlaneExecute.executeCommand("gem uninstall ykcitool -a -x", "gem install ykcitool", "")
      exit! code unless code == 0
    end

    desc "uninstall", "uninstall self"
    def uninstall()
      require 'actions/YKFastlaneExecute'
      code = YKFastlane::YKFastlaneExecute.executeCommand("gem uninstall ykcitool -a -x", "", "")
      exit! code unless code == 0
    end

  end
end
