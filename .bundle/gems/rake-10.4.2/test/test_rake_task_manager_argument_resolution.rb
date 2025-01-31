require File.expand_path('../helper', __FILE__)

class TestRakeTaskManagerArgumentResolution < Rake::TestCase

  def test_good_arg_patterns
    assert_equal [:t, [], []],       task(:t)
    assert_equal [:t, [], [:x]],     task(:t => :x)
    assert_equal [:t, [], [:x, :y]], task(:t => [:x, :y])

    assert_equal [:t, [:a, :b], []],       task(:t, [:a, :b])
    assert_equal [:t, [:a, :b], [:x]],     task(:t, [:a, :b] => :x)
    assert_equal [:t, [:a, :b], [:x, :y]], task(:t, [:a, :b] => [:x, :y])
  end

  def task(*args)
    tm = Rake::TestCase::TaskManager.new
    tm.resolve_args(args)
  end
end
