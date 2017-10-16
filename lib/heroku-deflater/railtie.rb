require 'rack/deflater'
require 'heroku-deflater/skip_binary'
require 'heroku-deflater/serve_zipped_assets'
require 'heroku-deflater/cache_control_manager'

module HerokuDeflater
  class Railtie < Rails::Railtie
    initializer 'heroku_deflater.configure_rails_initialization' do |app|
      app.middleware.insert_before ActionDispatch::Static, Rack::Deflater
      app.middleware.insert_before ActionDispatch::Static, HerokuDeflater::SkipBinary
      if defined?(::Sprockets) == "constant"
        app.middleware.insert_before Rack::Deflater, HerokuDeflater::ServeZippedAssets,
          app.paths['public'].first, app.config.assets.prefix, self.class.cache_control_manager(app)
      end
    end

    # Set default Cache-Control headers to 24 hours.
    # The configuration block in config/application.rb overrides this.
    config.before_initialize do |app|
      cache_control = cache_control_manager(app)
      cache_control.setup_max_age(86400)
    end

    def self.cache_control_manager(app)
      @_cache_control_manager ||= CacheControlManager.new(app)
    end
  end
end
