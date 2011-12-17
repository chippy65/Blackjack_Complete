require 'test_helper'
require '../app/models/cardtable.rb'

class CardtableTest < Test::Unit::TestCase
  # Replace this with your real tests.
#  test "the truth" do
#    assert true
#  end
  def test_basic
    assert_equal(24, setBet(24))
  end
end
