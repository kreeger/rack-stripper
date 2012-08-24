# Rack::Stripper: not as sexy as it sounds

Rack::Stripper merely performs `String#strip` on the body of the response. I wrote this out of a need for this when Rails sends out RSS feeds (for some reason, the XML instruction is replaced with a blank line on outgoing RSS responses).

## Installation

Add this line to your application's Gemfile and `bundle install` it:

    gem 'rack-stripper'

Rack::Stripper is Rack middleware and can be used with any Rack-based application. In `config/initializers`, create new file called `middleware.rb` or something. Place the following code in it.

    require 'rack/stripper'
    config.middleware.use Rack::Stripper

Then you'll see `Rack::Stripper` when you run `rake middleware`. Simple as that.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

I made this. I released it under the [WTFPL](http://sam.zoy.org/wtfpl). See LICENSE for details, if you're into that sort of thing.
