require 'yaml'
require 'json'

module YKFastlane

  module Tools
    def self.green(string)
      "\033[0;32m#{string}\e[0m"
    end

    def self.UI(string)
      puts(self.green(string))
    end

    def self.show_prompt
      print green(">")
    end

    def self.yk_ask(question)
      answer = ""
      loop do
        puts "\n#{question}?"
        show_prompt()
        answer = STDIN.gets.chomp

        break if answer.length > 0

        print "\nYou need to provide an answer."
      end
      puts "answier:#{answer}"
      answer
    end

    def self.yk_ask_with_answers(question, possible_answers)
      print "\n#{question}? ["
      print_info = Proc.new {
        possible_answers_string = possible_answers.each_with_index do |answer, i|
          _answer = (i == 0) ? answer.underlined : answer
          print " " + _answer
          print(" /") if i != possible_answers.length - 1
        end
        print " ]\n"
      }
      print_info.call

      answer = ""
      loop do
        show_prompt()
        answer = STDIN.gets.chomp

        answer = "yes" if answer == "y"
        answer = "no" if answer == "n"

        # default to first answer
        if answer == ""
          answer = possible_answers[0].downcase
          print answer.yellow
        end

        break if possible_answers.map { |a| a.downcase }.include? answer

        print "\nPossible answers are ["
        print_info.call
      end

      answer
    end

    def self.load_yml(path)
      if File.exist?(path) == false
        FileUtils.makedirs(File.dirname(path))
        File.new(path, 'w+')
      end

      f = File.open(path)
      yml = YAML.load(f, symbolize_names: false)
      f.close
      yml = {} if yml == false #空yml的时候， yml = false
      yml
    end

    def self.display_yml(path)
      puts Tools::green(JSON.pretty_generate(load_yml(path)))
    end

    def self.load_yml_value(path, key)
      yml = load_yml(path)
      yml = {} if yml == false #空yml的时候， yml = false
      re = yml[key].blank? ? nil : yml[key]
      re
    end

    def self.update_yml(qustion, path, key, value)
      yml = load_yml(path)

      updateFlag = :yes
      if value.blank? #外部未传该参数需要通过问答形式，获取该参数
        value = Tools.yk_ask("please input #{Tools::green(qustion)}")

        if yml[key].blank? == false #需要确认修改
          puts "#{key} existed:#{yml[key]}"
          updateFlag = Tools.yk_ask_with_answers("Are you sure to update #{self.green(qustion)}", ["Yes", "No"]).to_sym
        end
      end
      yml[key] = value unless updateFlag != :yes
      c_path = Helper::YKCONFIG_PATH
      f = File.open(path, "w+")
      YAML.dump(yml, f, symbolize_names: false)
      f.close
    end

    def self.over_write_yml_dict(path, dict)
      f = File.open(path, "w+")
      YAML.dump(dict, f, symbolize_names: false)
      f.close
    end

    def self.clone_git_repository(remote, destinationPath)
      begin
        puts "start clone:#{remote}"
        cloneResult = Git::clone(remote, destinationPath, :log => Logger.new(Logger::Severity::INFO))
        puts "clone_result:#{cloneResult}"
      rescue Git::GitExecuteError => e
        puts "clone failed:#{e}"
        return 1 #任务失败
      end
      return 0
    end

    def self.git_pull(path)
      begin
        git = Git::open(path)
        git.add()
        git.reset_hard()
        curbranch = git.current_branch
        git.pull('origin', curbranch)
      rescue Git::GitExecuteError => e
        puts "pull remote failed:#{e}"
        return 1 #任务失败
      end

      return 0
    end

    def self.git_commit(path, msg)
      git = Git::open(path)
      git.add()
      curbranch = git.current_branch
      begin
        git.commit("update:#{msg}")
      rescue Git::GitExecuteError => e
        puts "commit update execption:#{e}"
      end

      status = git.status()
      if status.untracked.count != 0 || status.changed.count != 0
        puts "git not clean, work failed"
        return 1
      else
        puts "git clean, work success"
        git.push('origin', curbranch)
        return 0
      end
    end

    def self.notify_message_to_enterprise_wechat(msg, status)
      puts "should send failed message to enterprise wechat:\"#{self.green(msg)}\""
      exit!(status) unless status == 0
    end

  end
end