require 'rack/deflater'
require 'heroku-deflater/skip_images'

module HerokuDeflater
  class Railtie < Rails::Railtie
    initializer "heroku_deflater.configure_rails_initialization" do |app|
      app.middleware.insert_before ActionDispatch::Static, Rack::Deflater
      app.middleware.insert_before ActionDispatch::Static, HerokuDeflater::SkipImages
    end

    config.after_initialize do |app|
      app.config.static_cache_control ||= "public, max-age=86400"
    end
  end
end
