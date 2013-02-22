require 'rack/deflater'
require 'heroku-deflater/skip_binary'

module HerokuDeflater
  class Railtie < Rails::Railtie
    initializer "heroku_deflater.configure_rails_initialization" do |app|
      app.middleware.insert_before ActionDispatch::Static, Rack::Deflater
      app.middleware.insert_before ActionDispatch::Static, HerokuDeflater::SkipBinary
    end

    # Set default Cache-Control headers to one week.
    # The configuration block in config/application.rb overrides this.
    config.before_configuration do |app|
      app.config.static_cache_control = 'public, max-age=604800'
    end
  end
end
