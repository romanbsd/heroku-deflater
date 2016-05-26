require 'rack/mock'
require 'rack/static'
require 'heroku-deflater/serve_zipped_assets'
require 'heroku-deflater/cache_control_manager'

describe HerokuDeflater::ServeZippedAssets do
  def process(path, accept_encoding = 'compress, gzip, deflate')
    env = Rack::MockRequest.env_for(path)
    env['HTTP_ACCEPT_ENCODING'] = accept_encoding
    app.call(env)
  end

  def app
    @app ||= begin
      root_path = File.expand_path('../fixtures', __FILE__)
      cache_control_manager = HerokuDeflater::CacheControlManager.new(nil)
      allow(cache_control_manager).to receive(:cache_control_headers) { 'public, max-age=86400' }
      mock = lambda { |env| [404, {'X-Cascade' => 'pass'}, []] }
      described_class.new(mock, root_path, '/assets', cache_control_manager)
    end
  end

  it 'does nothing for clients which do not want gzip' do
    status, headers, body = process('/assets/spec.js', nil)
    expect(status).to eq(404)
  end

  it 'handles the pre-gzipped assets' do
    status, headers, body = process('/assets/spec.js')
    expect(status).to eq(200)
  end

  it 'has correct content type' do
    status, headers, body = process('/assets/spec.js')
    expect(headers['Content-Type']).to eq('application/javascript')
  end

  it 'has correct content encoding' do
    status, headers, body = process('/assets/spec.js')
    expect(headers['Content-Encoding']).to eq('gzip')
  end

  it 'has correct content length' do
    status, headers, body = process('/assets/spec.js')
    expect(headers['Content-Length']).to eq('86')
  end

  it 'has correct cache control' do
    status, headers, body = process('/assets/spec.js')
    expect(headers['Cache-Control']).to eq('public, max-age=86400')
  end

  it 'does not serve non-gzipped assets' do
    status, headers, body = process('/assets/spec2.js')
    expect(status).to eq(404)
  end

  it 'does not serve anything from non-asset directories' do
    status, headers, body = process('/non-assets/spec.js')
    expect(status).to eq(404)
  end
end
