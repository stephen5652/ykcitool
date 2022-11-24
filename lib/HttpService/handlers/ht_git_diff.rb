module YKHttpModule
  require 'HttpService/handlers/handler_base'
  class HTGitDiff < YKHttpModule::YKHttpHandlerBase
    require 'GitTools/yk_git_utility'
    def self.path
      "/ci/git_diff"
    end

    def run_post
      super

      url = self.req_body["remote"]
      start = self.req_body["start"]
      finish = self.req_body["finish"]

      result = YKGitUtility.new(url).diff_from_to(start, finish)

      self.resp_data = result.data
      self.status = result.status ? 1 : 0
      self.msg = result.message
      self.detail = result.detail
    end

    def run_get
      super

      url = self.query_hash["remote"]
      start = self.query_hash["start"]
      finish = self.query_hash["finish"]

      result = YKGitUtility.new(url).diff_from_to(start, finish)

      self.resp_data = result.data
      self.status = result.status ? 1 : 0
      self.msg = result.message
      self.detail = result.detail
    end

  end
end