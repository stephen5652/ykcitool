require 'ykfastlane'
require 'rails'

@SCRIPT_PATH = Pathname.new(__FILE__).realpath.dirname
@YKCONFIG_PATH = File.join(File.expand_path(Dir.home), '.ykfastlaneEnv')
@YKRUNING_PATH = File.expand_path(Dir.pwd)

module Ykfastlane
  class YKFastlaneExecute
    def self.executeCommand(commandShell_pre, commandShell)
      excuteStr = " "
      excuteStr << "#{commandShell_pre} && " unless commandShell_pre.blank?
      excuteStr << commandShell unless commandShell.blank?

      puts "START COMMAND:#{excuteStr}"
      system(excuteStr)
      result = $?
      puts "command result[#{result.class}]:#{result}"
      code = result.exitstatus if result.is_a?(Process::Status)

      if code != 0
        #任务失败, 此处需要发送企业微信的通知到开发群
        puts "should report error to developer group"
      end

      code
    end

    def self.exchangOptionMapToStr(optionHash)
      paras = {}
      optionHash.each_pair { |k, v| paras[k] = v }
      puts "paras:#{paras.dup}"

      puts "$YKRUNING_PATH:#{@YKRUNING_PATH}"
      workspace_path = @YKRUNING_PATH
      workspace_path = paras["xcworkspace"] unless paras["xcworkspace"].blank?
      paras[:xcworkspace] = workspace_path
      paras[:script_run_path] = @YKRUNING_PATH

      puts "options_after:#{paras}"
      option_str = ""
      paras.each_pair do |k, v|
        option_str << " #{k}:\"#{v}\""
      end
      option_str
    end

    def self.executeFastlaneLane(lane_name, optionHash)
      option_str = exchangOptionMapToStr(optionHash)
      command = "fastlane #{lane_name} #{option_str}" unless option_str.blank?

      command_pre = "export LANG=en_US.UTF-8 && export LANGUAGE=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && which ruby"
      command_pre << " && cd #{Ykfastlane::FASTLANE_SCRIPT_PATH}"

      executeCommand(command_pre, command)
    end

  end

end