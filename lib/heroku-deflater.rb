require 'heroku-deflater/railtie'

module HerokuDeflater
  def self.rails_version_5?
    Rails::VERSION::MAJOR >= 5
  end
end
