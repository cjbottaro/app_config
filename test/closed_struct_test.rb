require 'test/unit'
require 'app_config'

class ClosedStructTest < Test::Unit::TestCase

  def test_from_hash
    s = ClosedStruct.new :a => "a", "b" => "b", :c => 123
    assert_equal "a", s.a
    assert_equal "b", s.b
    assert_equal 123, s.c
    assert_raise(NoMethodError){ s.d }
  end
  
  def test_from_array
    s = ClosedStruct.new :a, :b, :c
    s.b = "b"
    assert_nil s.a
    assert_equal "b", s.b
    assert_nil s.c
    assert_raise(NoMethodError){ s.d }
  end
  
  def test_nested_hash
    s = ClosedStruct.r_new :a => :a, :b => { :c => :c }, :d => :d
    assert_equal :c, s.b.c
  end
  
  def test_nested_hashes_in_array
    s = ClosedStruct.r_new :a => :a, :b => [ {:c => :c }, { :d => :d } ], :e => :e
    assert_equal :c, s.b[0].c
  end

end