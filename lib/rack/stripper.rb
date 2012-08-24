require 'rack'

module Rack
  class Stripper
    VERSION = '1.0.0'

    attr_accessor :add_xml_instruction

    def initialize(app, options={})
      @app = app
      self.add_xml_instruction = options[:add_xml_instruction] || false
    end

    def call(env)
      call!(env)
    end

    # Threadsave version using a shallow copy of env; shamelessly inspired by rack-tidy
    # http://github.com/rbialek/rack-tidy
    def call!(env)
      @env = env.dup
      status, headers, response = @app.call(@env)
      stripped_body = response.respond_to?(:body) ? process_body(response.body) : nil
      response = Rack::Response.new(stripped_body || response, status, headers)
      response.finish
      response.to_a
    end

    protected

    def process_body(body)
      body = body[0] if body.is_a?(Array)
      body.strip!
      if self.add_xml_instruction && doesnt_have_xml_instruction_already?(body)
        body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n#{body}"
      end
      body
    end

    def doesnt_have_xml_instruction_already?(body)
      match = body.match /<?xml version=/
      match.nil?
    end
  end
end