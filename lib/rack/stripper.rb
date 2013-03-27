require 'rack'

module Rack
  class Stripper
    VERSION = '1.1.1'

    attr_accessor :add_xml_instruction
    attr_accessor :is_xml_response

    def initialize(app, options={})
      @app = app
      @add_xml_instruction = options[:add_xml_instruction] || false
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      status, headers, response = @app.call(env)

      if status != 200
        return [status, headers, response]
      end

      if headers.has_key?('Content-Type')
        self.is_xml_response = !headers['Content-Type'].match(/xml/).nil?
      end

      if response.respond_to?(:body=)
        response.body = process_body(response.body)
        if headers.has_key?('Content-Length')
          headers['Content-Length'] = response.body.bytesize
        end
      end

      [status, headers, response]
    end

    protected

    def process_body(body)
      body = body[0] if body.is_a?(Array)
      body.strip!
      if @add_xml_instruction && @is_xml_response && lacks_instruction?(body)
        body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n#{body}"
      end
      body
    end

    # Determines if an instruction exists. In the safe case, say it already exists so we don't
    # put doubles in, because that'd be worse than not having one at all.
    #
    # @param [String] body The body of the text.
    #
    # @return [Boolean] true if the content doesn't have an XML instruction, false if it does.
    def lacks_instruction?(body)
      body.index('<?xml ').nil? rescue false
    end
  end
end
