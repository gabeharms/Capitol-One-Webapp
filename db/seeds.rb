# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


800.times do |n|
  first_name  = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "customer-#{n+1}@seniorproject.org"
  password = "password"
  Customer.create!(first_name:  first_name,
               last_name: last_name,
               email: email,
               password:              password,
               password_confirmation: password)
               
end

200.times do |n|
  first_name  = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "employee-#{n+1}@seniorproject.org"
  password = "password"
  Employee.create!(first_name:  first_name,
               last_name: last_name,
               email: email,
               password:              password,
               password_confirmation: password)
end




catagories = ['Checking Account', 'Savings Account', 'Credit Card', 'Customer Settings', 'Lost Password', 'Issue with Website']
catagories.each do |i|
  name = i
  TicketCatagory.create(name: name)
end

statuses = ['Active','Resolved']
statuses.each do |s|
  TicketStatus.create(status: s)
end

titles = ['How do I find my account balance', 'Can someone help me get new checks', 'I dont know how to change my password', 
            'The website isnt working, and I need to access my account', 'Am I eligible for a credit card', 'I want to create an account for my son',
            'Im lost how can I pay my credit card', 'I would like to close my account', 'How can I apply for a loan', 'Is it possible to combine my saving/checking account with my credit card account',
            'What are the differences between all of your credit cards', 'My credit card rewards points arent showing up', 'There is a charge on my statement that I didnt make',
            'I lost my debit card. What should I do', 'I believe that my account has been hacked. I would like to reset my password', 'Who should I contact about identity theft',
            'Does capital one provide cash advances', 'How do I set up a link to another bank account to transfer funds?', 'Where can I find my bank account routing number?', 'Do I have to come in to the bank to deposit a check?',
            'I lost my check book. What should I do?', 'Is this the fastest way to get in touch with Capital One?', 'I would like to open another account. What is the best way to do that?',
            'How do I use the rewards that I have collected so far?', 'What is my credit limit?', 'Why do vendors ask me for my ID when I pay with my credit card?', 'Is there a new security chip in my credit card?',
            'When I take a picture of a check to deposit it, is the picture saved in my account?', 'Can I use the card overseas?', 'Are there any international charges on withdrawing funds?',
            'Can I open an account for my kid under my account?', 'What are the benefits of the Venture Card?', 'What is the different between the Venture and Quicksilver cards?', 'Is the Sparks card better than the Venture card?',
            'Can you help me? I am having trouble navagating my online account page', 'I have a question about credit line increases', 'How would I apply for an auto loan?', 'What are the IRS forms 1089 and 1099?',
            'What are todays mortgage rates?', 'How often do my interest rates change?', 'What is a fixed rate mortgage?', 'How do I know what loan is best for me?', 'Do I need a down payment on refinancing?']

status_id = [1,1,1,2] #allows 75% chance of being 'in progress'

7000.times do
  title = titles.sample
  visible = true
  created_at = Time.at((7.months.ago.to_f - Time.now.to_f)*rand + Time.now.to_f)
  
  
  
  if rand(1..2) == 1
    created_by = false
    employee_id = Employee.order("RANDOM()").first.id
    claimed_at = created_at
  else
    employee_id = nil
    created_by = true
    claimed_at = nil
  end
  
  status = status_id.sample
  
  
  new_ticket = Customer.order("RANDOM()").first.tickets.create!(title: title, employee_id: employee_id, ticket_status_id: status, ticket_category_id: rand(1..catagories.count), created_by_customer: created_by, visible: visible, created_at: created_at, claimed_at: claimed_at)
  
  if status == 2 
    Rate.create!(rater_id: 1, rateable_id: new_ticket.id, stars: rand(1..5).to_f, rateable_type: "Ticket", dimension: "experience", created_at: Time.at((7.months.ago.to_f - Time.now.to_f)*rand + Time.now.to_f))
  end

  if employee_id == nil
    choser = [0,1,1,1,1,2]
  else
    choser = [0,1,1,2,2,3,3,3,4,5]
  end
  upper_bound = choser.sample
  
  (0..upper_bound).each do
    employee = (employee_id != nil && rand(1..2) == 1) ? employee_id : nil
    initiator = (employee == nil) ? false : true
    new_ticket.comments.create!(employee_id: employee, initiator: initiator, message: "auto populated comment", created_at: Time.at((7.months.ago.to_f - Time.now.to_f)*rand + Time.now.to_f))
  end
  
  if new_ticket.employee_id == nil && rand(1..2) == 1
    new_ticket.employee_id = Employee.order("RANDOM()").first.id
    new_ticket.claimed_at = Time.at((created_at.to_f - (created_at.to_f + 3.days))*rand + Time.now.to_f)
  end   

end

operatingSystem = ["Windows 7", "Windows 8.1", "Linux", "Mac OS X", "Android", "iOS"]
deviceTypes = ["Desktop", "Tablet", "Mobile"]
behavior = ["$click", "$click", "$view", "$view", "$change", "$submit"]
states = ["New Jersey", "New Jersey","Pennsylvannia", "Pennsylvannia", "Pennsylvannia", "Pennsylvannia", "New York", "New York", "Maryland", "Virginia", "Virginia", "Virginia", "Florida", "California"]

1000.times do
  Visit.create!(os: operatingSystem.sample, device_type: deviceTypes.sample, region: states.sample, started_at: Time.at((7.months.ago.to_f - Time.now.to_f)*rand + Time.now.to_f) )
  Ahoy::Event.create!(name: behavior.sample, time: Time.at((7.months.ago.to_f - Time.now.to_f)*rand + Time.now.to_f))
end


def rand_in_range(from, to)
  rand * (to - from) + from
end

############################################
# Create Accounts for zach and wesley
############################################
first_name  = "Zach"
last_name =  "Employee"
email = "zach-employee@seniorproject.org"
password = "baseball"
zachEmployee = Employee.create!(first_name:  first_name,
             last_name: last_name,
             email: email,
             password:              password,
             password_confirmation: password)

first_name  = "Wesley"
last_name =  "Employee"
email = "wesley-employee@seniorproject.org"
password = "football"
wesleyEmployee = Employee.create!(first_name:  first_name,
             last_name: last_name,
             email: email,
             password:              password,
             password_confirmation: password)
             
first_name  = "Zach"
last_name =  "Customer"
email = "zach-customer@seniorproject.org"
password = "baseball"
Customer.create!(first_name:  first_name,
             last_name: last_name,
             email: email,
             password:              password,
             password_confirmation: password)
             
first_name  = "Wesley"
last_name =  "Customer"
email = "wesley-customer@seniorproject.org"
password = "football"
Customer.create!(first_name:  first_name,
             last_name: last_name,
             email: email,
             password:              password,
             password_confirmation: password)
             
15.times do
  title = titles.sample
  visible = true
  
  if rand(1..2) == 1
    created_by = false
    employee_id = zachEmployee.id
  else
    employee_id = wesleyEmployee.id
    created_by = false
  end
  
  Customer.order("RANDOM()").first.tickets.create!(title: title, employee_id: employee_id, ticket_status_id: status_id.sample, ticket_category_id: rand(1..catagories.count), created_by_customer: created_by, visible: visible, created_at: Time.at((7.days.ago.to_f - Time.now.to_f)*rand + Time.now.to_f) )
end