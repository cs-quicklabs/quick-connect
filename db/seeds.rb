# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Group.create([{ name: "Simple activities", group: "activity" }, { name: "Sport", group: "activity" }, { name: "Food", group: "activity" }, { name: "Cultural activities", group: "activity" }, { name: "Work & education", group: "event" },
              { name: "Family & relationships", group: "event" }, { name: "Home & living", group: "event" }, { name: "Home & wellness", group: "event" }, { name: "Travel & experiences", group: "event" }])
