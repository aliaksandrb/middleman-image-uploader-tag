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

  def test_upload_to_cloud_expects_image_path_argument
    assert_raises Middleman::ImageUploaderTag::NotFound do
      cdn.new(config).upload_to_cloud nil
    end

    assert_raises Middleman::ImageUploaderTag::NotFound do
      cdn.new(config).upload_to_cloud 'fake.jpg'
    end
  end

  def test_upload_to_cloud
    image_path = extension.image_location('test.jpg')
    `touch #{image_path}` unless File.exists? image_path

    mock = Minitest::Mock.new
    mock.expect :upload, { 'secure_url': 'http://cdn.com/test.jpg' }, [
      image_path,
      { use_filename: true, unique_filename: false }
    ]

    Cloudinary.stub_const(:Uploader, mock) do
      cdn.new(config).upload_to_cloud(image_path)
    end

    mock.verify
  end

  def test_get_remote_link_expects_image_path_argument
    assert_raises Middleman::ImageUploaderTag::NotFound do
      cdn.new(config).get_remote_link nil
    end

    assert_raises Middleman::ImageUploaderTag::NotFound do
      cdn.new(config).get_remote_link 'fake.jpg'
    end
  end

  def test_get_remote_link
    image_path = extension.image_location('test.jpg')
    `touch #{image_path}` unless File.exists? image_path

    Cloudinary::Uploader.instance_eval do
      def upload(file, options)
        { 'secure_url': 'http://cdn.com/test.jpg' }
      end
    end

    assert_equal 'http://cdn.com/test.jpg', cdn.new(config).get_remote_link(image_path)
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

  def extension
    app = Class.new(Middleman::Application)
    app.config.images_dir = 'images'
    Middleman::ImageUploaderTag::Extension.new(app).class
  end
end

