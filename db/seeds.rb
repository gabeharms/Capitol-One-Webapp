# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



99.times do |n|
  first_name  = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "customer-#{n+1}@railstutorial.org"
  password = "password"
  Customer.create!(first_name:  first_name,
               last_name: last_name,
               email: email,
               password:              password,
               password_confirmation: password)
               

end

99.times do |n|
  first_name  = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "employee-#{n+1}@railstutorial.org"
  password = "password"
  Employee.create!(first_name:  first_name,
               last_name: last_name,
               email: email,
               password:              password,
               password_confirmation: password)
end

customers = Customer.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count = 4)
  customers.each { |customer| customer.tickets.create!(title: title) }
end