require 'ostruct'
require 'rack/stripper'

class DummyWare

  def initialize(body)
    @body = body
  end

  def call(env)
    status = 200
    headers = {'Content-Type' => 'application/xml; charset=utf-8'}
    response = Rack::Response.new(@body, status, headers)
    response.to_a
  end
end