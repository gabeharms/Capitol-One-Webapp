require 'test_helper'

class TicketsInterfaceTest < ActionDispatch::IntegrationTest
 
  def setup
    @customer = customers(:michael)
    @employee = employees(:john)
    @ticket = tickets(:orange)
  end

  def teardown
    @customer = nil
    @employee = nil
    @ticket = nil
  end

  test "ticket interface customer" do
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
    #assert_match title, response.body
    
    # Delete a post.
    #assert_select 'a', text: 'delete'
    first_ticket = @customer.tickets.paginate(page: 1).first
    assert_difference 'Ticket.count', -1 do
      delete ticket_path(first_ticket)
    end
    
    # Visit a different customer.
    get customer_path(customers(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "ticket interface employee" do
    employee_log_in_as(@employee)
    assert is_employee_logged_in?
    
    # Invalid submission
    assert_no_difference 'Ticket.count' do
      post tickets_path, ticket: { title: "" }
    end
    #employee_id = @employee.id
    employee_id = "/employees/12345678"
    assert_redirected_to employee_id

    # **Need to implement still
    # Claim a ticket
    #ticket_orange = "/tickets/1"

    #assert_select "a[href=?]", ticket_orange do
    #  assert_select value: "claim"
    #end
    
    # Valid submission
    title = "This ticket was created by John Sustersic"
    assert_difference 'Ticket.count', 1 do
      post tickets_path, ticket: { title: title }
    end
    assert_redirected_to employee_id
    
    follow_redirect!
    
    # **Need to implement still
    # Resolve a ticket


    #assert_match title, response.body
    
    # Delete a post.
    #assert_select 'a', text: 'delete'
    first_ticket = @employee.tickets.paginate(page: 1).first
    assert_difference 'Ticket.count', -1 do
      delete ticket_path(first_ticket)

    end
    
  end
end
