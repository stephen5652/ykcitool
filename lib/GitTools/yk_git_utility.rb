require 'GitTools/git_work_result'
module YKCiTool
  class YKGitUtility
    require 'GitTools/git_analysis'
    include YKFastlane::GitAnalysis

    attr_reader :url

    def initialize(url)
      puts("YKGitUtility initialize:#{url}")
      @url = url
    end

    def project_path
      return "" if self.url.blank?
      project_name = File.basename(self.url, ".*")
      path = File.join(YKFastlane::GitAnalysis::YKCI_GIT_ROOT_DIR, project_name)
    end

    def diff_from_to(start, finish)
      puts "start:#{start} --> finish:#{finish}"

      path = self.project_path
      analysis_result = YKFastlane::GitAnalysis::GitWorkResult.new(false, nil, "Clone failed", "Clone failed")
      if File.exists?(path) == false
        analysis_result = YKFastlane::GitAnalysis.clone_remote(self.url, path)
        return analysis_result unless analysis_result.status == true
      end

      return YKFastlane::GitAnalysis::GitWorkResult.new(
        true,
        {
          "remote" => self.url,
          "path" => path,
          "start" => start,
          "finish" => finish,
        },
        "Work success", "Work success"
      )
    end
  end
end