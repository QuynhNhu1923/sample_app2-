# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Micropost.create!(content: "This is the first micropost.")
# Micropost.create!(content: "Here"s another one.")
# Micropost.create!(content: "And a third micropost for testing.")

# Create a main sample user
User.create!(name:  "Example User",
                email: "example@railstutorial.org",
                birthday: "1990-01-01",
                gender:   "male",
                password:              "foobar",
                password_confirmation: "foobar",
                admin: true, activated: true, activated_at: Time.zone.now) #  Đặt người dùng đầu tiên làm admin
# Generate a bunch of additional users.
30.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                email: email,
                birthday: "1990-01-01",
                gender:   "male",
                password:              password,
                password_confirmation: password,
                activated: true, activated_at: Time.zone.now)
end
