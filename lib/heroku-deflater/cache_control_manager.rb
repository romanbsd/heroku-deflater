module HerokuDeflater
  class CacheControlManager
    DEFAULT_MAX_AGE = '86400'.freeze
    attr_reader :app, :max_age

    def initialize(app)
      @app = app
      @max_age = DEFAULT_MAX_AGE
    end

    def setup_max_age(max_age)
      @max_age = max_age
      if rails_version_5?
        app.config.public_file_server.headers ||= {}
        app.config.public_file_server.headers['Cache-Control'] = cache_control
      else
        app.config.static_cache_control = cache_control
      end
    end

    def cache_control_headers
      if rails_version_5?
        { 'Cache-Control' => cache_control }
      else
        cache_control
      end
    end

    private

    def rails_version_5?
      Rails::VERSION::MAJOR >= 5
    end

    def cache_control
      @_cache_control ||= "public, max-age=#{max_age}"
    end
  end
end
