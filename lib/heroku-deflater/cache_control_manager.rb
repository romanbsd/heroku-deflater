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
      if rails_version_5?
        headers = app.config.public_file_server.headers ||= {}
        headers['Cache-Control'] ||= "public, max-age=#{max_age}"
      else
        headers = app.config.static_cache_control
      end
      headers
    end

    private

    def rails_version_5?
      Rails::VERSION::MAJOR >= 5
    end
  end
end
