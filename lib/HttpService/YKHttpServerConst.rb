module YKHttpModule
  module YKHttpConst
    @yk_cur_server
    def self.cur_server
      @yk_cur_server
    end
    def self.set_cur_server(ser)
      @yk_cur_server = ser
    end
  end
end
