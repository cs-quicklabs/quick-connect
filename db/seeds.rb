# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Group.create([{ name: "Simple activities", category: "activity" }, { name: "Sport", category: "activity" }, { name: "Food", category: "activity" }, { name: "Cultural activities", category: "activity" }, { name: "Work & education", category: "event" },
              { name: "Family & relationships", category: "event" }, { name: "Home & living", category: "event" }, { name: "Home & wellness", category: "event" }, { name: "Travel & experiences", category: "event" },
              { name: "Other", category: "activity" }, { name: "Other", category: "event" }])
