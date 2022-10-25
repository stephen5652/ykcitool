require 'actions/YKFastlaneExecute'

module YKFastlane
  class Git < YKFastlane::SubCommandBase
    desc "analysis_commit", "analysis git commit"
    option :path, :require => false, :type => :string, :aliases => :p, :desc => 'the path should be analysised'

    def analysis_commit()
      self.analysis_git_commit_execute(options)
    end

    no_commands do
      def analysis_git_commit_execute(options)
        puts("analysis git commit info execute:#{options}")
        path = options[:path].blank? ? Dir.pwd : File.expand_path(options[:path])
        puts("path:#{path}")
      end
    end

  end
end