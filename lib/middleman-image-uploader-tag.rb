require 'middleman-core'
require 'middleman/image-uploader-tag/exceptions'
require 'middleman/image-uploader-tag/extension'
require 'middleman/image-uploader-tag/cdns/base.rb'
require 'middleman/image-uploader-tag/cdns/cloudinary.rb'

::Middleman::Extensions.register(
  :image_uploader_tag, ::Middleman::ImageUploaderTag::Extension
)
