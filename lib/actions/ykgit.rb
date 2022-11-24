require 'actions/YKFastlaneExecute'

module YKFastlane
  class YKGit < YKFastlane::SubCommandBase
    require "GitTools/git_analysis"
    include YKFastlane::GitAnalysis

    desc "diff_to_tag", "analysis git commit"
    option :path, :require => false, :type => :string, :aliases => :p, :desc => 'the path should be analysised'

    def diff_to_tag()
      self.analysis_git_commit_execute(options)
    end

    no_commands do
      def analysis_git_commit_execute(options)
        puts("analysis git commit info execute:#{options}")
        path = options[:path].blank? ? Dir.pwd : File.expand_path(options[:path])
        puts("path:#{path}")
        diff_hash = self.commit_tag_diff(path)

        YKFastlane::Tools.UI(diff_hash.to_json)
        diff_hash
      end
    end

  end
end