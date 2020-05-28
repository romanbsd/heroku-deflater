require 'spec_helper'

describe HerokuDeflater::SkipBinary do
  let(:env) { Rack::MockRequest.env_for('/') }

  def app_returning_type(type, headers = {})
    lambda { |env| [200, {'Content-Type' => type}.merge(headers), ['']] }
  end

  def process(type, headers = {})
    described_class.new(app_returning_type(type, headers)).call(env)[1]
  end

  it "forbids compressing of binary types" do
    %w[application/gzip application/pdf image/jpeg].each do |type|
      headers = process(type)
      expect(headers['Cache-Control'].to_s).to include('no-transform')
    end
  end

  it "allows compressing of text types" do
    %w[text/plain text/html application/json application/javascript
    application/rss+xml application/vnd.api+json].each do |type|
      headers = process(type)
      expect(headers['Cache-Control'].to_s).not_to include('no-transform')
    end
  end

  it "adds to existing headers" do
    headers = process('image/gif', 'Cache-Control' => 'public')
    expect(headers['Cache-Control']).to eq('public, no-transform')
  end

  it "doesn't add 'no-transform' if it's already present" do
    headers = process('image/gif', 'Cache-Control' => 'public, no-transform')
    expect(headers['Cache-Control']).to eq('public, no-transform')
  end
end
