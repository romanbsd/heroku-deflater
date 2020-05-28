require 'rails'
require 'rack/mock'
require 'rack/static'

require 'heroku-deflater'
require 'heroku-deflater/serve_zipped_assets'
require 'heroku-deflater/cache_control_manager'
require 'heroku-deflater/skip_binary'

class Rails5App
  def config
    @_config ||= Config.new
  end

  class Config
    attr_accessor :headers

    def initialize
      @headers = {}
    end

    def public_file_server
      self
    end
  end
end

class Rails4App
  def config
    @_config ||= Config.new
  end

  class Config
    attr_accessor :static_cache_control
  end
end
