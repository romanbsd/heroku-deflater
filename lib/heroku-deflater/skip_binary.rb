module HerokuDeflater
  # Add a no-transform Cache-Control header to binary types, so they won't get gzipped
  class SkipBinary
    def initialize(app)
      @app = app
    end

    WHITELIST = [
      %r{^text/},
      'application/javascript',
      %r{^application/json},
      %r{^application/.*?xml},
      'application/x-font-ttf',
      'font/opentype',
      'image/svg+xml'
    ].freeze

    def call(env)
      status, headers, body = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)
      content_type = headers['Content-Type']
      cache_control = headers['Cache-Control'].to_s.downcase

      unless cache_control.include?('no-transform') or WHITELIST.any? { |type| type === content_type }
        if cache_control.empty?
          headers['Cache-Control'] = 'no-transform'
        else
          headers['Cache-Control'] += ', no-transform'
        end
      end

      body.close if body.respond_to?(:close)
      [status, headers, body]
    end
  end
end
