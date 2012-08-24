require 'spec_helper'

rss_feed = <<-EOS

<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
    <channel>
        <title>Lookit me, I'm an RSS feed!</title>
        <link>http://feedvalidator.org/</link>
        <description>An RSS feed.</description>
        <language>en-us</language>
        <copyright>Your mom, last night.</copyright>
        <docs>http://blogs.law.harvard.edu/tech/rss</docs>
    </channel>
</rss>
EOS

describe :rack do
  describe :stripper do
    before(:each) { @stripper = Rack::Stripper.new(DummyWare.new(rss_feed), {}) }

    describe :_call do
      it 'should clean up the body of a response' do
        status, headers, response = @stripper._call({})
        response.body.should_not be_nil
        body = response.body.first
        body.should start_with('<rss')
        body.should == rss_feed.strip
      end

      it 'should add an instruction if told to do so' do
        opts = { add_xml_instruction: true }
        @stripper = Rack::Stripper.new(DummyWare.new(rss_feed), opts)
        status, headers, response = @stripper._call({})
        response.body.should_not be_nil
        body = response.body.first
        body.should start_with('<?xml version')
      end
    end

    describe :doesnt_have_xml_instruction_already? do
      let(:method) { :doesnt_have_xml_instruction_already? }

      it 'should match on a basic xml instruction' do
        string = "<?xml version='1.0'?>"
        result = @stripper.send(method, string)
        result.should be_false
      end

      it 'should match on a slightly more complicated xml instruction' do
        string = "<?xml version=\"1.0\" standalone=\"no\"?>"
        result = @stripper.send(method, string)
        result.should be_false
      end

      it 'should match on a crazy nutshit complicated xml instruction' do
        string = "<?xml version=\"1.0\" standalone=\"no\" charset=\"utf8\"?>"
        result = @stripper.send(method, string)
        result.should be_false
      end

      it "shouln't match on a missing xml instruction" do
        string = "<?xml version='1.0' />"
        result = @stripper.send(method, string)
        result.should be_false
      end
    end

    describe :process_body do
      let(:method) { :process_body }
      let(:before_and_after) { "      here's a sweet-ass string      " }
      let(:line_breaks) { "\n\n\nhere's a sweet-ass string\n\n\n" }
      let(:none_before) { "here's another string    \n"}
      let(:none_after) { "  \n  here's another string"}

      it 'should strip whitespace from the beginning of a string' do
        result = @stripper.send(method, before_and_after)
        result.should start_with("here's")
        result.should_not start_with(' ')

        result = @stripper.send(method, line_breaks)
        result.should start_with("here's")
        result.should_not start_with("\n")
      end

      it 'should strip whitespace from the end of a string' do
        result = @stripper.send(method, before_and_after)
        result.should end_with("string")
        result.should_not end_with(' ')

        result = @stripper.send(method, line_breaks)
        result.should end_with("string")
        result.should_not end_with("\n")
      end

      it "should leave a string alone at the beginning if there's not whitespace there" do
        result = @stripper.send(method, none_before)
        result.should end_with("string")
        result.should start_with("here's")
        result.should_not end_with(" ")
        result.should_not end_with("\n")
      end

      it "should leave a string alone at the end if there's not whitespace there" do
        result = @stripper.send(method, none_after)
        result.should end_with("string")
        result.should start_with("here's")
        result.should_not start_with(" ")
        result.should_not start_with("\n")
      end
    end
  end
end