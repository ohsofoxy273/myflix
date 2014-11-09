# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

4.times do 
	Video.create(title: "Monk",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: 1)

	Video.create(title: "Family guy",
							 description: "A funny  TV show",
							 small_cover_url: "/tmp/family_guy.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: 2)

	Video.create(title: "Futurama",
							 description: "A funny show",
							 small_cover_url: "/tmp/futurama.jpg",
							 large_cover_url: "/tmp/futurama.jpg",
							 category_id: 3)

	Video.create(title: "South Park",
							 description: "A funny cartoon show",
							 small_cover_url: "/tmp/south_park.jpg",
							 large_cover_url: "/tmp/south_park.jpg",
							 category_id: 3)

	Video.create(title: "Monk",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: 4)

	Video.create(title: "Monk",
							 description: "A funny show",
							 small_cover_url: "/tmp/monk.jpg",
							 large_cover_url: "/tmp/monk_large.jpg",
							 category_id: 1)
end

Category.create(name: 'TV_comedies')
Category.create(name: 'TV_dramas')
Category.create(name: 'horror')
Category.create(name: 'reality_TV')
