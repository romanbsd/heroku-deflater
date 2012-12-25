module HerokuDeflater
  # Add a no-transform Cache-Control header to images, so they won't get gzipped
  class SkipImages
    def initialize(app)
      @app = app
    end

    # TODO: whitelist rather than blacklist
    def call(env)
      status, headers, body = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)
      if headers['Content-Type'].to_s.start_with?('image/')
        if headers['Cache-Control'].nil? or headers['Cache-Control'].empty?
          headers['Cache-Control'] = 'no-transform'
        else
          headers['Cache-Control'] += ', no-transform'
        end
      end
      [status, headers, body]
    end
  end
end
