module HerokuDeflater
  # Add a no-transform Cache-Control header to binary types, so they won't get gzipped
  class SkipBinary
    def initialize(app)
      @app = app
    end

    WHITELIST = %w(
      application/atom+xml
      application/javascript
      aplication/json
      application/rss+xml
      application/vnd.ms-fontobject
      application/x-font-ttf
      application/xhtml+xml
      application/xml
      font/opentype
      image/svg+xml
      image/x-icon
      text/css
      text/html
      text/plain
      text/x-component
      text/xml
    ).freeze

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
      [status, headers, body]
    end
  end
end
