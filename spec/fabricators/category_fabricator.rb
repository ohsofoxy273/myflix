Fabricator(:category) do
	name { Faker::Lorem.word }
	videos
end