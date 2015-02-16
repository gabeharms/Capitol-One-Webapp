require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
 
  def setup
    @ticket = tickets(:orange)
  
  end

  test "should redirect create when not logged in" do
    
    assert_no_difference 'Ticket.count' do
      post :create, ticket: { title: "Lorem ipsum" }
    end
    assert_redirected_to customer_login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Ticket.count' do
      delete :destroy, id: @ticket
    end
    assert_redirected_to customer_login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    customer_log_in_as(customers(:michael))
    ticket = tickets(:ants)
    assert_no_difference 'Ticket.count' do
      delete :destroy, id: ticket
    end
    assert_redirected_to customer_login_url
  end
end
