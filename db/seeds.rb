# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

fem_url = 'https://randomuser.me/api?results=5&gender=female'
male_url = 'https://randomuser.me/api?results=5&gender=male'
[fem_url, male_url].each do |url|
  HTTParty.get(url).parsed_response['results'].each do |obj|
    person = obj['user']
    User.create(
      name: "#{person['name']['first']} #{person['name']['last']}",
      email: "#{person['email']}",
      image_url: "#{person['picture']['medium']}",
      password: "#{person['password']}"
    )
  end
end
