
def green(string)
  "\033[0;32m#{string}\e[0m"
end


module YKFastlane
  module Helper
    '' '脚本当前工作路径' ''
    YKRUNING_PATH = File.expand_path(Dir.pwd)
    '' 'fastlane脚本放置路径' ''
    YKFastlne_SCRIPT_PATH = File.expand_path(File.join(Dir.home, '.ykfastlane_config', 'ykfastlane_script'))
    '' '配置文件放置路' ''
    YKCONFIG_PATH = File.expand_path(File.join(Dir.home, '.ykfastlane_config/evnConfig.yml'))

    def show_prompt
      print green(">")
    end

    def ask(question)
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

    def ask_with_answers(question, possible_answers)
      print "\n#{question}? ["
      print_info = Proc.new {
        possible_answers_string = possible_answers.each_with_index do |answer, i|
          puts "answer:#{answer}"
          _answer = (i == 0) ? answer.underlined : answer
          print " " + _answer
          print(" /") if i != possible_answers.length - 1
        end
        print " ]\n"
      }
      print_info.call

      answer = ""
      loop do
        @message_bank.show_prompt
        answer = gets.downcase.chomp

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
  end
end