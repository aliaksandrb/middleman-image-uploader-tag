require './test/test_helper'
require 'minitest/stub_const'
require 'fileutils'

class ExtensionTest < Minitest::Test
  attr_reader :application, :ext_instance, :ext_class

  def setup
    @application = Class.new(Middleman::Application)
    set_app_config({ images_dir: 'images' })
    @ext_instance = Middleman::ImageUploaderTag::Extension.new(@application)
    @ext_instance.app = @application
    @ext_class = @ext_instance.class
  end

  def test_implemented
    assert Middleman::ImageUploaderTag::Extension
  end

  def test_app
    assert_equal application, ext_class.app
  end

  def test_provider_options
    assert_equal ext_instance.options, ext_class.provider_options
  end

  def test_remote_images_dir
    set_provider_options ext_class, remote_images_dir: 'test_folder'
    assert_equal 'test_folder', ext_class.remote_images_dir

    set_provider_options ext_class, remote_images_dir: nil
    assert_equal 'remote_images', ext_class.remote_images_dir
  end

  def test_create_images_dir!
    remote_images_dir = File.join(application.root, 'source', application.images_dir, ext_class.remote_images_dir)

    assert Dir.exists?(remote_images_dir)

    FileUtils.rm_rf(remote_images_dir)
    refute Dir.exists?(remote_images_dir)

    ext_class.create_images_dir!
    assert Dir.exists?(remote_images_dir)
  end

  def test_helpers_being_defined
    assert_respond_to application, :remote_image_tag
    assert_respond_to application, :remote_image_tag_link
  end

  def test_remote_image_tag_helper
    # I`m not sure if it`s the right way..
    create_fake_image!('test.jpg')
    image = ext_class.image_location('test.jpg')
    called = false
    name_called = ''

    application.class.class_eval do
      define_method :image_tag do |name, params|
        params ||= {}
        called = true
        name_called = name
        'test.jpg'
      end
    end

    application.stub :remote_image_tag_link, image do
      application.remote_image_tag 'test.jpg'
    end

    assert_equal true, called
    assert_equal image, name_called

    called = false
    application.stub :remote_image_tag_link, image do
      application.remote_image_tag 'test.jpg', true, alt: 'hello'
    end

    assert_equal true, called
  end

  def test_remote_image_tag_link_helper
    create_fake_image!('test.jpg')
    image = ext_class.image_location('test.jpg')

    mock = Minitest::Mock.new
    mock.expect :get_remote_path, image, ['test.jpg', false]

    ::Middleman::ImageUploaderTag.stub_const(:Extension, mock) do
      application.remote_image_tag_link 'test.jpg'
    end

    mock.verify

    mock = Minitest::Mock.new
    mock.expect :get_remote_path, image, ['test.jpg', true]

    ::Middleman::ImageUploaderTag.stub_const(:Extension, mock) do
      application.remote_image_tag_link 'test.jpg', true
    end

    mock.verify
  end

  def test_image_location
    remote_images_dir = File.join(application.root, 'source',
                                  application.images_dir, ext_class.remote_images_dir)

    assert_equal remote_images_dir + '/test.jpg', ext_class.image_location('test.jpg')
    assert_equal remote_images_dir + '/test.jpg', ext_class.image_location('/test.jpg')
    assert_equal remote_images_dir + '/test/test.jpg', ext_class.image_location('test/test.jpg')
  end

  def test_provider
    set_provider_options ext_class, provider_options_stub

    assert_instance_of Middleman::ImageUploaderTag::CloudinaryCDN, ext_class.provider
  end

  def test_get_remote_path_during_development
    remote_images_dir = File.join(application.images_dir, ext_class.remote_images_dir)
    create_fake_image!('test.jpg')
    create_fake_image!('test/test.jpg')

    set_app_config environment: :development

    assert_equal File.join('/', remote_images_dir, 'test.jpg'), ext_class.get_remote_path('test.jpg')
    assert_equal File.join('/', remote_images_dir, '/test.jpg'), ext_class.get_remote_path('/test.jpg')
    assert_equal File.join('/', remote_images_dir, 'test/test.jpg'), ext_class.get_remote_path('test/test.jpg')
  end

  def test_get_remote_path_raises_exception_for_absent_image
    image = ext_class.image_location('/test.jpg')
    File.delete(image) if File.exist? image

    assert_raises Middleman::ImageUploaderTag::NotFound do
      ext_class.get_remote_path 'test.jpg'
    end
  end

  def test_get_remote_path_during_build
    set_app_config environment: :build
    create_fake_image!('test.jpg')
    image = ext_class.image_location('test.jpg')

    mock = Minitest::Mock.new
    mock.expect :instance_of?, true, [::Middleman::ImageUploaderTag::CloudinaryCDN]
    mock.expect :get_remote_link, image, [image, false]

    ext_class.stub :provider, mock do
      ext_class.get_remote_path 'test.jpg'
    end
    mock.verify

    mock = Minitest::Mock.new
    mock.expect :instance_of?, true, [::Middleman::ImageUploaderTag::CloudinaryCDN]
    mock.expect :get_remote_link, image, [image, true]

    ext_class.stub :provider, mock do
      ext_class.get_remote_path 'test.jpg', true
    end
    mock.verify

    mock = Minitest::Mock.new
    mock.expect :instance_of?, false, [::Middleman::ImageUploaderTag::CloudinaryCDN]
    mock.expect :get_remote_link, image, [image]

    ext_class.stub :provider, mock do
      ext_class.get_remote_path 'test.jpg', true
    end
    mock.verify
  end

  private

  def set_app_config(options = {})
    options.each do |key, value|
      application.config.public_send(:"#{key}=", value)
    end
  end

  def set_provider_options(extension, options = {})
    provider_options = extension.provider_options

    options.each do |key, value|
      if provider_options.respond_to?(key)
        # reset internal state because of the nil guard technic
        extension.class_variable_set("@@#{key}", nil)

        provider_options.public_send(:"#{key}=", value)
      end
    end
  end

  def provider_options_stub
    { provider: :cloudinary,
      provider_config: { api_key: 'test', api_secret: 'test', cloud_name: 'test' }
    }
  end

  def create_fake_image!(name)
    image = ext_class.image_location(name)
    dir = File.dirname(image)
    Dir.mkdir(dir) unless Dir.exists? dir

    `touch #{image}` unless File.exists? image
  end

end

