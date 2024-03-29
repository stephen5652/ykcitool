require 'rails'
require 'thor'

require "ykfastlane/helper"

module YKCitool

  class SubCommandBase < Thor
    class_option :verbose, :type => :boolean
    def self.exit_on_failure?
      true
    end

    def self.banner(command, namespace = nil, subcommand = false)
      "#{basename} #{subcommand_prefix} #{command.usage}"
    end

    def self.subcommand_prefix
      self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
    end
  end

  class YKFastlaneExecute
    def self.executeCommand(commandShell_pre, commandShell, workTitle)
      excuteStr = " "
      excuteStr << "#{commandShell_pre}" unless commandShell_pre.blank?
      excuteStr << " && #{commandShell}" unless commandShell.blank?

      puts "START COMMAND:#{excuteStr}"
      code = 1
      system(excuteStr)
      result = $?
      puts "command result[#{result.class}]:#{result}"
      code = result.exitstatus if result.is_a?(Process::Status)

      #### 以下代码注释，因为fastlane脚本中做了任务失败时候的通知
      # if code != 0
      #   #任务失败, 此处需要发送企业微信的通知到开发群
      #   puts "should report error to developer group"
      #   noticeCmd = commandShell_pre
      #   commandShell = commandShell.gsub!( " ", "\\ " )
      #   commandShell = commandShell.gsub!( "\"", "\\\"")
      #   noticeCmd << "&&fastlane wx_message_notice wx_notice_token:#{Helper::YKWECHAT_ROBOT_TOKEN} msg_title:\"CI work failed\" notice_message:\"#{commandShell}\""
      #   puts "notice_command:#{noticeCmd}"
      #   system(noticeCmd)
      # end

      code
    end

    def self.exchangOptionMapToStr(optionHash)
      paras = {}
      optionHash.each_pair { |k, v| paras[k] = v }
      puts "paras:#{paras.dup}"

      puts "YKRUNING_PATH:#{Helper::YKRUNING_PATH}"
      workspace_path = Helper::YKRUNING_PATH
      workspace_path = paras["xcworkspace"] unless paras["xcworkspace"].blank?
      paras[:xcworkspace] = workspace_path
      paras[:script_run_path] = Helper::YKRUNING_PATH

      puts "options_after:#{paras}"
      option_str = ""
      paras.each_pair do |k, v|
        option_str << " #{k}:\"#{v}\""
      end
      option_str
    end

    def self.executeFastlaneLane(lane_name, optionHash)
      dict = {}
      dict.update(optionHash)
      if optionHash[:wxwork_access_token].blank?
        wxtoken = YKCitool::Helper.load_config_value(YKCitool::Helper::K_wx_access_token)
        dict.update({:wxwork_access_token => wxtoken})
      end

      option_str = exchangOptionMapToStr(dict)
      command = "fastlane #{lane_name} #{option_str}" unless option_str.blank?

      command_pre = "export LANG=en_US.UTF-8 && export LANGUAGE=en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && which ruby"
      command_pre << " && cd #{YKCitool::Helper.fastlane_script()}"

      executeCommand(command_pre, command, lane_name)
    end

  end

end