# Middleman Image Uploader Tag

`middleman-image-uploader-tag` is an extension for the [Middleman] static site generator that adds special tag helpers with functionality of uploading images into a external services as CDN's and remote storages.

## The Reason

If you start a new blog generated by the Middleman and hosted at the GitHub static pages, soon you become realize that pushing big images into the repository has a few drawbacks:

- the speed of deploy through the git is very low
- it pollutes your repository with huge files (GitHub is definitely not Flckr)
- it caches for 10 minutes only because of GitHub CDNs Cache-Control headers. So your readers would not be happy to redownload huge backgrounds or photos each time they visit your site..
- ...

## Concept

During development phase nothing is changed. To prevent redundancy uploading into remote hosting (while you are looking for different pictures, changing their sizes and so on), local images used as ussually.

But at the build time all images would be uploaded into remote hosting, and their relative paths replaced for appropriate absolute urls.
That gives you a possibility to control caching time of images, as well as other options that your CDN may provides you, separately.

## Important Note

At the moment only the [Cloudinary] CDN is supported. But it is easy to add any new one.

## Installation

Nothing special:

`gem install middleman-image-uploader-tag`

Or just add the following line into your `Gemfile`:

`gem 'middleman-image-uploader-tag'`

 and after run `bundle install`.

Also you can install the latest code directly from repository with:

`gem 'middleman-image-uploader-tag', git: 'https://github.com/aliaksandrb/middleman-image-uploader-tag.git'`


## Configuration

Activate extension in your `config.rb`, providing credentials for remote provider:

```ruby
activate :image_uploader_tag do |e|
  e.remote_images_dir = 'remote_images'
  e.provider = :cloudinary
  e.provider_config = {
    cloud_name: ENV['CLOUDINARY_CLOUD_NAME'],
    api_key: ENV['CLOUDINARY_API_KEY'],
    api_secret: ENV['CLOUDINARY_API_SECRET'],
    enhance_image_tag: false,
    static_image_support: true,
    secure: true
  }
end
```

Note: the `remote_images_dir` sets the only folder images being uploaded.

It is optional and by default has the value `'remote_images'`. You can change it but be sure to place it NOT within the images directory of the Middleman, just somewhere in the application root folder.

## Usage

Now in your views you can use a few new helpers:

Example for `.slim` or `.haml` templates

```ruby
= remote_image_tag 'test.png', alt: 'hello'

= remote_image_tag 'backgrounds/test.png', alt: 'hello'
```

If you want to use it in your `.md` templates for posts content, you should rename them, adding additional proccessing level.

For example you had an post `source/articles/2015-05-21-welcome.html.markdown` then you need to rename it to `source/articles/2015-05-21-welcome.html.markdown.erb` (note `.erb` at the end).

After you can use a bit different helper:

```ruby
![MYIMAGE](<%= remote_image_tag_link 'test.png' %>)
```

or as simple as

```ruby
<%= remote_image_tag 'test.png' %>
```

The difference between `remote_image_tag` and `remote_image_tag_link` is that the first wraps link into `<img>` tag, but the other just produces the raw link as `https://cdn.blablabla.com/test.png`.

[middleman]: http://middlemanapp.com/
[cloudinary]: https://cloudinary.com/
___

Any feedback or issue report appreciated!