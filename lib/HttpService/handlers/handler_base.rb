module YKHttpModule
  require 'webrick'
  require 'HttpService/YKHttpServerConst'

  class YKHttpHandlerBase
    require 'json'

    YKHTTP_CODE_PATHERROR = 1001

    attr_accessor :req, :resp, :status, :resp_data, :msg, :detail
    attr_reader :logger, :path, :http_method
    attr_reader :query_hash, :req_body

    def self.path
      nil
    end

    def initialize(request, response)
      WEBrick::HTTPRequest
      @req = request
      @path = request.path
      @http_method = request.request_method
      @query_hash = request.query
      @req_body = JSON.parse(request.body)
      #WEBrick::HTTPResponse
      @resp = response
      #WEBrick::Log
      @logger = YKHttpModule::YKHttpConst.cur_server.logger

      @status = YKHTTP_CODE_PATHERROR
      @resp_data = {}
      @msg = "Service work failed !"
      @detail = "Service work failed !"
    end

    def self.failed(request, response, code)
      reason = ""
      if code == YKHTTP_CODE_PATHERROR
        reason = "Error path: #{request.path}"
      end

      response.body = {
        :code => code,
        :data => nil ,
        :msg => "Service work failed",
        :detail => reason,
      }.to_json
    end

    def execute
      if self.http_method == "POST"
        run_post()
      elsif self.http_method == "GET"
        run_get()
      end

      finish
    end

    def finish
      reason = self.detail
      if self.status == YKHTTP_CODE_PATHERROR
        reason = "Error path: #{self.path}"
      end

      self.resp.body = {
        :code => self.status,
        :data => self.resp_data,
        :msg => self.msg,
        :detail => reason,
      }.to_json
    end

    def run_get
      nil
    end

    def run_post
      nil
    end
  end

end