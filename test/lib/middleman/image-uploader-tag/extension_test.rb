require './test/test_helper'

class ExtensionTest < Minitest::Test
  def setup
    @application = Class.new(Middleman::Application)
    @ext_instance = Middleman::ImageUploaderTag::Extension.new(@application)
    @ext_class = @ext_instance.class
  end

  def test_implemented
    assert Middleman::ImageUploaderTag::Extension
  end

  def test_app
    assert_equal @application, @ext_class.app
  end

  def test_provider_options
    assert_equal @ext_instance.options, @ext_class.provider_options
  end

  def test_remote_images_dir
    set_provider_options @ext_class, { remote_images_dir: 'test_folder' }
    assert_equal 'test_folder', @ext_class.remote_images_dir

    set_provider_options @ext_class, { remote_images_dir: nil }
    assert_equal 'remote_images', @ext_class.remote_images_dir
  end

  def test_create_images_dir!
    remote_images_dir = File.join(@application.root, 'source', @ext_class.remote_images_dir)

    assert Dir.exists?(remote_images_dir)

    Dir.rmdir(remote_images_dir)
    refute Dir.exists?(remote_images_dir)

    @ext_class.create_images_dir!
    assert Dir.exists?(remote_images_dir)
  end

  def test_helpers
    skip
  end

  def test_image_location
    remote_images_dir = File.join(@application.root, 'source', @ext_class.remote_images_dir)

    assert_equal remote_images_dir + '/test.jpg', @ext_class.image_location('test.jpg')
    assert_equal remote_images_dir + '/test.jpg', @ext_class.image_location('/test.jpg')
    assert_equal remote_images_dir + '/test/test.jpg', @ext_class.image_location('test/test.jpg')
  end

  def test_provider
    skip
  end

  def test_get_remote_path
    skip
  end

  private

  def set_provider_options(extension, options = {})
    provider_options = extension.provider_options

    options.each do |key, value|
      if provider_options.respond_to?(key)
        # reset internal state because of the nil guard technic
        extension.class_variable_set("@@#{key}", nil)

        provider_options.public_send("#{key}=", value)
      end
    end
  end
end

