require './test/test_helper'

class ExtensionTest < Minitest::Test

  def test_implemented
    assert Middleman::ImageUploaderTag::Extension
  end

end
