require 'test_helper'

class TicketsInterfaceTest < ActionDispatch::IntegrationTest
 
  def setup
    @customer = customers(:michael)
  end

  test "ticket interface" do
    customer_log_in_as(@customer)
    assert is_customer_logged_in?
    
    # Invalid submission
    assert_no_difference 'Ticket.count' do
      post tickets_path, ticket: { title: "" }
    end
    assert_redirected_to @customer
    
    
    # Valid submission
    title = "This ticket really ties the room together"
    assert_difference 'Ticket.count', 1 do
      post tickets_path, ticket: { title: title }
    end
    assert_redirected_to @customer
    
    follow_redirect!
    assert_match title, response.body
    
    # Delete a post.
    assert_select 'a', text: 'delete'
    first_ticket = @customer.tickets.paginate(page: 1).first
    assert_difference 'Ticket.count', -1 do
      delete ticket_path(first_ticket)
    end
    
    # Visit a different customer.
    get customer_path(customers(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
