# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

master_user = User.create(name: "Michael Fox", email: "user@example.com", password: "password" )

comedies = Category.create(name: "Comedy")
dramas = Category.create(name: "Drama")
horror = Category.create(name: "Horror")
reality = Category.create(name: "Reality_TV")

4.times do 
	Video.create(title: "Futurama",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: comedies.id)
	Video.create(title: "Family guy",
							 description: "A funny  TV show",
							 small_cover_url: "/tmp/family_guy.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: dramas.id)

	Video.create(title: "Futurama",
							 description: "A funny show",
							 small_cover_url: "/tmp/futurama.jpg",
							 large_cover_url: "/tmp/futurama.jpg",
							 category_id: comedies.id)

	Video.create(title: "South Park",
							 description: "A funny cartoon show",
							 small_cover_url: "/tmp/south_park.jpg",
							 large_cover_url: "/tmp/south_park.jpg",
							 category_id: dramas.id)

	Video.create(title: "South_park",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: horror.id)

	Video.create(title: "South Park",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: reality.id)
end

kevin = User.create(name: "Kevin", email: "kevin@example.com", password: "password")
review1 = Review.create(user: kevin, video: Video.find(1), rating: 4, content: "A great movie to watch with the family")
review2 = Review.create(user: kevin, video: Video.find(1), rating: 2, content: "It was not bad, could be better")