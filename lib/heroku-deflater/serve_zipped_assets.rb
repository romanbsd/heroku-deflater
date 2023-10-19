require 'action_controller'
require 'action_dispatch/middleware/static'

if Rails::VERSION::MAJOR < 7
  # Deprecated in Rails 7.0, and removed in 7.1
  require 'active_support/core_ext/uri'
end

# Adapted from https://gist.github.com/guyboltonking/2152663
#
# Taken from: https://github.com/mattolson/heroku_rails_deflate
#
module HerokuDeflater
  class ServeZippedAssets
    def initialize(app, root, paths, cache_control_manager)
      @app = app
      @paths = paths.map { |p| p.chomp('/') + '/' }

      if HerokuDeflater.rails_version_5?
        @file_handler = ActionDispatch::FileHandler.new(root, headers: cache_control_manager.cache_control_headers)
      else
        @file_handler = ActionDispatch::FileHandler.new(root, cache_control_manager.cache_control_headers)
      end
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'GET'
        request = Rack::Request.new(env)
        encoding = Rack::Utils.select_best_encoding(%w(gzip identity), request.accept_encoding)

        if encoding == 'gzip'
          # See if gzipped version exists in assets directory
          compressed_path = env['PATH_INFO'] + '.gz'

          if compressed_path.start_with?(*@paths) && (match = @file_handler.match?(compressed_path))
            # Get the FileHandler to serve up the gzipped file, then strip the .gz suffix
            env['PATH_INFO'] = match
            status, headers, body = @file_handler.call(env)
            env['PATH_INFO'].chomp!('.gz')

            # Set the Vary HTTP header.
            vary = headers['Vary'].to_s.split(',').map(&:strip)

            unless vary.include?('*') || vary.include?('Accept-Encoding')
              headers['Vary'] = vary.push('Accept-Encoding').join(',')
            end

            # Add encoding and type
            headers['Content-Encoding'] = 'gzip'
            headers['Content-Type'] = Rack::Mime.mime_type(File.extname(env['PATH_INFO']), 'text/plain')

            body.close if body.respond_to?(:close)
            return [status, headers, body]
          end
        end
      end

      @app.call(env)
    end
  end
end
