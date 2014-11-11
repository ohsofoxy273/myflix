source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails'
gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
	gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
end

