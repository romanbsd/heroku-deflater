require 'rack/deflater'
require 'heroku-deflater/skip_binary'
require 'heroku-deflater/serve_zipped_assets'

module HerokuDeflater
  class Railtie < Rails::Railtie
    initializer 'heroku_deflater.configure_rails_initialization' do |app|
      app.middleware.insert_before ActionDispatch::Static, Rack::Deflater
      app.middleware.insert_before ActionDispatch::Static, HerokuDeflater::SkipBinary
      app.middleware.insert_before Rack::Deflater, HerokuDeflater::ServeZippedAssets,
        app.paths['public'].first, app.config.assets.prefix, app.config.static_cache_control
    end

    # Set default Cache-Control headers to one week.
    CACHE_CONTROL_HEADER = 'public, max-age=604800'.freeze

    # The configuration block in config/application.rb overrides this.
    if Rails.version >= '5.0.0'.freeze
      config.before_configuration do |app|
        app.config.public_file_server.headers = { 'Cache-Control' => CACHE_CONTROL_HEADER }
      end
    else
      config.before_configuration do |app|
        app.config.static_cache_control = CACHE_CONTROL_HEADER
      end
    end
  end
end
