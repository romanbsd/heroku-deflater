require 'heroku-deflater/cache_control_manager'
require 'rails'

describe HerokuDeflater::CacheControlManager do
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

  class Rails4App < Rails::Application
  end

  context 'Rails 4.x and below' do
    def rails_4_app
      @_rails_4_app ||= Rails4App.new
    end

    before { described_class.any_instance.stub(:rails_version_5?).and_return(false) }
    subject { described_class.new(rails_4_app) }

    it 'sets max age for static_cache_control config option' do
      subject.setup_max_age(64800)
      rails_4_app.config.static_cache_control.should eq('public, max-age=64800')
    end

    it 'cache_control_headers returns cache control option' do
      subject.setup_max_age(64800)
      subject.cache_control_headers.should eq('public, max-age=64800')
    end
  end

  context 'Rails 5' do
    def rails_5_app
      @_rails_5_app ||= Rails5App.new
    end

    before { described_class.any_instance.stub(:rails_version_5?).and_return(true) }
    subject { described_class.new(rails_5_app) }

    it 'sets max age for public_file_server config option' do
      subject.setup_max_age(64800)
      rails_5_app.config.public_file_server.headers['Cache-Control'].should eq('public, max-age=64800')
    end

    it 'cache_control_headers returns hash cache control headers' do
      subject.setup_max_age(64800)
      subject.cache_control_headers.should eq(headers: { 'Cache-Control' =>'public, max-age=64800'})
    end
  end
end
