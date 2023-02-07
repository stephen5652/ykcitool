# frozen_string_literal: true
require 'ykfastlane/helper'
require 'rails'

module YKFastlane
  class Module < YKFastlane::SubCommandBase
    include Helper

    desc "simple", "create simple module without demo"
    option :name, :require => true, :type => :string, :aliases => :n, :desc => 'module name'
    option :path, :require => false, :type => :string, :aliases => :p, :desc => 'module path'
    option :language, :require => false, :type => :string, :aliases => :l, :desc => 'module language objc/swift'

    def simple() end
  end
end