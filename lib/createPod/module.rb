# frozen_string_literal: true
require 'ykfastlane/helper'
require 'rails'

module YKCitool
  class Module < YKCitool::SubCommandBase
    include Helper

    desc "standard", "创建标准组件"
    option :name, :required => true, :type => :string, :aliases => :n, :desc => 'module name'
    option :language, :required => true, :type => :string, :aliases => :l, :desc => 'module language objc/swift'
    option :path, :required => false, :type => :string, :aliases => :p, :desc => 'module path'
    def standard()

    end
  end
end