# Rack::Stripper: not as sexy as it sounds

Rack::Stripper merely performs `String#strip` on the body of the response. I wrote this out of a need for this when Rails sends out RSS feeds (for some reason, the XML instruction is replaced with a blank line on outgoing RSS responses).

## Installation

Add this line to your application's Gemfile and `bundle install` it:

    gem 'rack-stripper'

Rack::Stripper is Rack middleware and can be used with any Rack-based application. In `config/application.rb`, place the following code.

    config.middleware.use Rack::Stripper

Then you'll see `Rack::Stripper` when you run `rake middleware`. Simple as that. More info about using Rack middleware with Rails can be found [here][rails]. If you'd like the middleware to ensure an XML instruction is added to the bodies to XML-based responses, make that line look like this.

    config.middleware.use Rack::Stripper, add_xml_instruction: true

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

I made this. I released it under the [WTFPL][]. See LICENSE for details, if you're into that sort of thing.

[rails]:     http://guides.rubyonrails.org/rails_on_rack.html
[WTFPL]:     http://sam.zoy.org/wtfpl