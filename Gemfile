# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

gem 'sequel', '~> 5.71'
gem 'sqlite3', '~> 1.6'

group :test do
  gem 'factory_bot', '~> 6.3'
  gem 'ffaker', '~> 2.22'
  gem 'rspec', '~> 3.12'
  gem 'webmock', '~> 3.19'
end

group :development do
  gem 'rubocop', '~> 1.56'
  gem 'rubocop-performance', '~> 1.19'
  gem 'rubocop-rspec', '~> 2.23'
end

group :test, :development do
  gem 'pry', '~> 0.14.2'
end
