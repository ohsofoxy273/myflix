source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails'
gem 'bcrypt', '3.1.7'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'
gem 'paratrooper'
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'stripe'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara-email'
end

group :production do
  gem 'rails_12factor'
  gem "sentry-raven" #, :github => "getsentry/raven-ruby"
end

