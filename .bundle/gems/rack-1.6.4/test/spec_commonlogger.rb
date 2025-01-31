require 'rack/commonlogger'
require 'rack/lint'
require 'rack/mock'

require 'logger'

describe Rack::CommonLogger do
  obj = 'foobar'
  length = obj.size

  app = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html", "Content-Length" => length.to_s},
     [obj]]}
  app_without_length = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html"},
     []]}
  app_with_zero_length = Rack::Lint.new lambda { |env|
    [200,
     {"Content-Type" => "text/html", "Content-Length" => "0"},
     []]}

  should "log to rack.errors by default" do
    res = Rack::MockRequest.new(Rack::CommonLogger.new(app)).get("/")

    res.errors.should.not.be.empty
    res.errors.should =~ /"GET \/ " 200 #{length} /
  end

  should "log to anything with +write+" do
    log = StringIO.new
    Rack::MockRequest.new(Rack::CommonLogger.new(app, log)).get("/")

    log.string.should =~ /"GET \/ " 200 #{length} /
  end

  should "work with standartd library logger" do
    logdev = StringIO.new
    log = Logger.new(logdev)
    Rack::MockRequest.new(Rack::CommonLogger.new(app, log)).get("/")

    logdev.string.should =~ /"GET \/ " 200 #{length} /
  end

  should "log - content length if header is missing" do
    res = Rack::MockRequest.new(Rack::CommonLogger.new(app_without_length)).get("/")

    res.errors.should.not.be.empty
    res.errors.should =~ /"GET \/ " 200 - /
  end

  should "log - content length if header is zero" do
    res = Rack::MockRequest.new(Rack::CommonLogger.new(app_with_zero_length)).get("/")

    res.errors.should.not.be.empty
    res.errors.should =~ /"GET \/ " 200 - /
  end

  def with_mock_time(t = 0)
    mc = class <<Time; self; end
    mc.send :alias_method, :old_now, :now
    mc.send :define_method, :now do
      at(t)
    end
    yield
  ensure
    mc.send :alias_method, :now, :old_now
  end

  should "log in common log format" do
    log = StringIO.new
    with_mock_time do
      Rack::MockRequest.new(Rack::CommonLogger.new(app, log)).get("/")
    end

    md = /- - - \[([^\]]+)\] "(\w+) \/ " (\d{3}) \d+ ([\d\.]+)/.match(log.string)
    md.should.not.equal nil
    time, method, status, duration = *md.captures
    time.should.equal Time.at(0).strftime("%d/%b/%Y:%H:%M:%S %z")
    method.should.equal "GET"
    status.should.equal "200"
    (0..1).should.include?(duration.to_f)
  end

  def length
    123
  end

  def self.obj
    "hello world"
  end
end
