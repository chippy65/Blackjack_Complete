require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    @u = User.new
    @u.init
    assert_equal(0, @u.games_played)
    assert_equal(0, @u.games_lost)
    assert_equal(0, @u.games_won)
    assert_equal(1000, @u.balance)
    assert_equal(1000, @u.cashflow)
    assert_equal(1, @u.num_sessions)
    assert_equal(0, @u.games_per_session_avg)

    assert true
  end
end
