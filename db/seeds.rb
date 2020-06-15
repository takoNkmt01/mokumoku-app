# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding: urf-8

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-25 13:00",
  end_at: "2020-04-25 15:00",
  user: User.first
)

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-26 13:00",
  end_at: "2020-04-26 15:00",
  user: User.find(3)
)

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-27 19:00",
  end_at: "2020-04-27 21:00",
  user: User.find(4)
)

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-24 18:00",
  end_at: "2020-04-24 20:00",
  user: User.find(5)
)

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-25 13:00",
  end_at: "2020-04-25 15:00",
  user: User.first
)

Event.create(
  title: "【勉強会】Rails勉強会",
  content: "初心者の方におすすめです!",
  overview: "みんなでRuby on Railsを勉強しよう",
  capacity: 2,
  start_at: "2020-04-25 13:00",
  end_at: "2020-04-25 15:00",
  user: User.first
)