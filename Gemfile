source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

gem "rails", "~> 7.0.2", ">= 7.0.2.3"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "interactor"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "pry"
  gem "rubocop", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "factory_bot_rails"
  gem "rspec-rails"
end
