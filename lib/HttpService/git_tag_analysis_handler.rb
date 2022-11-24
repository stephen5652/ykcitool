module YKHttpModule
  require 'GitTools/git_analysis'

  class GitTagDiff
    def call(req)
      puts("tag_diff[#{self}]:#{req}")
      [ 200, { }, [ "#{req}" ] ]
    end
  end

  class GitCommitDiff
    def call(req)
      puts("commit_diff[#{self}]:#{req}")
      YKFastlane::Init.new().list_all_configs
      path = Dir.pwd
      result = YKFastlane::GitAnalysis.commit_tag_diff(path)
      [ 200, { }, [ "#{result}" ] ]
    end
  end
end