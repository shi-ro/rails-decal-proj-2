require 'rack/lint'
require 'rack/mock'
require 'rack/runtime'

describe Rack::Runtime do
  def runtime_app(app, *args)
    Rack::Lint.new Rack::Runtime.new(app, *args)
  end
  
  def request
    Rack::MockRequest.env_for
  end
  
  it "sets X-Runtime is none is set" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    response = runtime_app(app).call(request)
    response[1]['X-Runtime'].should =~ /[\d\.]+/
  end

  it "doesn't set the X-Runtime if it is already set" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain', "X-Runtime" => "foobar"}, "Hello, World!"] }
    response = runtime_app(app).call(request)
    response[1]['X-Runtime'].should == "foobar"
  end

  should "allow a suffix to be set" do
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    response = runtime_app(app, "Test").call(request)
    response[1]['X-Runtime-Test'].should =~ /[\d\.]+/
  end

  should "allow multiple timers to be set" do
    app = lambda { |env| sleep 0.1; [200, {'Content-Type' => 'text/plain'}, "Hello, World!"] }
    runtime = runtime_app(app, "App")

    # wrap many times to guarantee a measurable difference
    100.times do |i|
      runtime = Rack::Runtime.new(runtime, i.to_s)
    end
    runtime = Rack::Runtime.new(runtime, "All")

    response = runtime.call(request)

    response[1]['X-Runtime-App'].should =~ /[\d\.]+/
    response[1]['X-Runtime-All'].should =~ /[\d\.]+/

    Float(response[1]['X-Runtime-All']).should > Float(response[1]['X-Runtime-App'])
  end
end
