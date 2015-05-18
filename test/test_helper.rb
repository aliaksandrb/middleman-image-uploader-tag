PROJECT_ROOT_PATH = File.dirname(File.dirname(__FILE__))
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-image-uploader-tag')
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman', 'image-uploader-tag',
                                     'cdns', 'cloudinary')
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'

ENV['MM_ROOT'] = File.join(PROJECT_ROOT_PATH, 'test', 'fixtures', 'test')

