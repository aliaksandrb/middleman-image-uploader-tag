require './test/test_helper'

require 'middleman-core'
require 'middleman-core/application'
require 'middleman-core/configuration'
require 'middleman-core/util'

class ExtensionTest < Minitest::Test
  def setup
    @application = Class.new(Middleman::Application)
    @extension = Middleman::ImageUploaderTag::Extension.new(@application).class
  end

  def test_implemented
    assert Middleman::ImageUploaderTag::Extension
  end

  def test_app
    assert_equal @application, @extension.app
  end
end
