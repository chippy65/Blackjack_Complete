require 'test_helper'
require 'app/models/cardtable.rb'

class CardtableTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
	@ct = Cardtable.new
	assert_equal(24, @ct.setBet(24))

	@ct.Deck.new
    #assert true
  end
end
