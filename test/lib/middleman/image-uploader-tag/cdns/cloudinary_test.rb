require './test/test_helper'

class CloudinaryCDNTest < Minitest::Test
  attr_reader :cdn

  def setup
    @cdn = Middleman::ImageUploaderTag::CloudinaryCDN
  end

  def test_implemented
    assert cdn
  end

  def test_config_required_for_initializing
    assert_raises ArgumentError do
      cdn.new
    end

    assert_instance_of cdn, cdn.new(config)
  end

  def test_initialization_set_properties_from_valid_config
    clear_config!
    cdn_config = Cloudinary.config

    assert_equal nil, cdn_config.cloud_name
    assert_equal nil, cdn_config.api_key
    assert_equal nil, cdn_config.api_secret
    assert_equal nil, cdn_config.enhance_image_tag
    assert_equal nil, cdn_config.static_image_support
    assert_equal nil, cdn_config.secure

    cdn.new config

    assert_equal config[:cloud_name], cdn_config.cloud_name
    assert_equal config[:api_key], cdn_config.api_key
    assert_equal config[:api_secret], cdn_config.api_secret
    assert_equal config[:enhance_image_tag], cdn_config.enhance_image_tag
    assert_equal config[:static_image_support], cdn_config.static_image_support
    assert_equal config[:secure], cdn_config.secure
  end

  def test_config_should_provide_required_options
    clear_config!

    cdn.const_get(:OBLIGATORY_OPTIONS).each do |option|
      assert_raises Middleman::ImageUploaderTag::AuthorizationRequired do
        bad_config = config
        bad_config.delete option
        cdn.new bad_config
      end
    end
  end

  def test_public_interface
    new_cdn = cdn.new(config)
    assert_respond_to new_cdn, :get_remote_link
    assert_respond_to new_cdn, :upload_to_cloud
  end

  def test_upload_to_cloud
    skip
  end

  def test_get_remote_link
    skip
  end

  private

  def config
    {
      cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
      api_key: ENV['CLOUDINARY_API_KEY'],
      api_secret: ENV['CLOUDINARY_API_SECRET'],
      enhance_image_tag: false,
      static_image_support: true,
      secure: true
    }
  end

  def clear_config!
    Cloudinary.class_variable_set(:@@config, OpenStruct.new({}))
  end
end

