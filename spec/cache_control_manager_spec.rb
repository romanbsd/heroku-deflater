require 'spec_helper'

describe HerokuDeflater::CacheControlManager do
  subject { described_class.new(app) }
  before { subject.setup_max_age(86400) }

  context 'Rails 4.x and below' do
    let(:app) { Rails4App.new }

    before do
      allow(HerokuDeflater).to receive(:rails_version_5?).and_return(false)
      subject.cache_control_headers
    end

    it 'sets max age for static_cache_control config option' do
      expect(app.config.static_cache_control).to eq('public, max-age=86400')
    end

    it 'cache_control_headers returns cache control option' do
      expect(subject.cache_control_headers).to eq('public, max-age=86400')
    end
  end

  context 'Rails 5' do
    let(:app) { Rails5App.new }

    before do
      allow(HerokuDeflater).to receive(:rails_version_5?).and_return(true)
      subject.cache_control_headers
    end

    it 'sets max age for public_file_server config option' do
      expect(app.config.public_file_server.headers['Cache-Control']).to eq('public, max-age=86400')
    end

    it 'cache_control_headers returns hash cache control headers' do
      expect(subject.cache_control_headers).to eq({'Cache-Control' =>'public, max-age=86400'})
    end
  end
end
