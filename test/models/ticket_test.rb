require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  
  def setup
    @customer = customers(:michael)
    @ticket = @customer.tickets.build(title:"Can't login")
    # Adding Employee tests in the future. Just trying to feel out customer
    # end right now
  end

  def teardown
    @customer = nil
    @ticket = nil
  end

  test "should be valid" do
    assert @ticket.valid?
  end

  test "user id should be present" do
    @ticket.customer_id = nil
    assert @ticket.valid?
  end

  test "content should be present " do
    @ticket.title = "   "
    assert_not @ticket.valid?
  end

  test "content should be at most 140 characters" do
    @ticket.title = "a" * 141
    assert_not @ticket.valid?
  end
  
  test "order should be most recent first" do
    assert_equal Ticket.first, tickets(:most_recent)
  end
end
