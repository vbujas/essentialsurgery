# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#admin = User.create(email:"alex@cybersuperpowers.com", username: "alex", password:"mapinteractive2014", role: "admin")
admin1 = User.create(email:"test@test.com", username: "admin", password:"admin", role: "admin")
 
#doctors = Doctor.all

#doctors.each do |doctor|
#  username = "#{doctor.first_name + doctor.last_name}".downcase.gsub(/\s+/, "")
#  user = User.create(email: doctor.email, username: username, password: "mapinteractive2014", role: "doctor")
#  doctor.update_column(:user_id, user.id)
#  puts "create user account for each doctor"
# end
