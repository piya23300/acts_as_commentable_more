source "https://rubygems.org"

# Declare your gem's dependencies in acts_as_commentable_more.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'

gem 'rails', "~> 4.2.1"

gem "codeclimate-test-reporter", group: :test, require: nil

group :development do
  gem 'bullet',         '4.13.2'
  gem 'spring',         '1.1.3'
  gem 'mina',           '0.3.0'
  gem 'hirb',           '0.7.2'
  gem 'better_errors',  '2.0.0'
  # gem 'debugger'
end

group :development, :test do
  gem 'rspec-rails',            '3.1.0'
  gem 'capybara',               '2.4.3'
  gem 'shoulda-matchers',       '2.7.0', require: false
  gem 'guard-rspec',            '4.3.1'
  gem 'simplecov',              '0.9.0', require: false
  gem 'spring-commands-rspec',  '1.0.2'
  gem 'factory_girl_rails',     '4.4.1'
  gem 'coveralls', require: false
end

group :test do
  # gem 'rspec-sidekiq'
end
