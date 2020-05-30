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
    end

    def cache_control_headers
      if HerokuDeflater.rails_version_5?
        headers = app.config.public_file_server.headers ||= {}
        headers['Cache-Control'] ||= "public, max-age=#{max_age}"
        headers
      else
        app.config.static_cache_control ||= "public, max-age=#{max_age}"
      end
    end
  end
end
