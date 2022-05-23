# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Customer.create(
  [
    { name: 'Marco', address: "Rome, Italy" },
    { name: 'Marek', address: "Warsaw, Poland" },
    { name: 'Sergey', address: "Moscow, Russia" },
    { name: 'Pablo', address: "Madrid, Spain" },
  ]
)

Product.create(
  [
    { name: 'Pasta' },
    { name: 'Bigos' },
    { name: 'Bliny' },
    { name: 'Paella' },
  ]
)

Order.create(
  [
    { customer: Customer.find_by(name: 'Marco'), product: Product.find_by(name: "Pasta"), paid_at: Date.yesterday, shipped_at: Date.yesterday },
    { customer: Customer.find_by(name: 'Marek'), product: Product.find_by(name: "Bigos"), paid_at: Date.today },
    { customer: Customer.find_by(name: 'Sergey'), product: Product.find_by(name: "Bliny"), created_at: Time.now },
    { customer: Customer.find_by(name: 'Pablo'), product: Product.find_by(name: "Paella"), created_at: Time.now - 1.week },
  ]
)