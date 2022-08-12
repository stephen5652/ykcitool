require 'actions/YKFastlaneExecute'

module YKFastlane
  class Pod < YKFastlane::SubCommandBase
    desc 'github_transfer', '迁移github三方库到移开gitlab.'
    long_desc <<-LONGDESC
    1. 需要在移开gitlab创建一个同名的git仓库.
    2. 尝试迁移所有tag, 当碰到迁移失败的tag的时候，并不会导致整个迁移的失败;
    3. 最终会输出迁移成功的数组和失败的数组
    LONGDESC
    option :orignal_url, :aliases => :o, :required => true, :type => :string, :desc => '原始源码仓库'
    option :ykgitlab_url, :aliases => :d, :required => true, :type => :string, :desc => '迁移的目标仓库'
    option :versions, :aliases => :s, :type => :string, :desc => '迁移的目标版本，多个的时候用空格\' \'隔开， 默认遍历尝试迁移所有的版本，比较耗时'
    option :wxwork_access_token, :aliases => :w, :type => :string, :desc => '用于将任务结果传给企业微信'

    def github_transfer()
      puts "github_pod_transfer"
      code = Ykfastlane::YKFastlaneExecute.executeFastlaneLane("github_pod_transfer", options)
      exit(code)
    end
  end
end