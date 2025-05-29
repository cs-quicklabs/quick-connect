source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby version app is using, [https://www.ruby-lang.org/en/downloads/]
ruby "3.3.0"

# Bundle edge Rails instead: gem 'rails', [https://github.com/rails/rails]
gem "rails", "8.0.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg"
gem "activerecord-import", git: "https://github.com/zdennis/activerecord-import"

# Use Puma as the app server [https://github.com/puma/puma]
gem "puma"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "1.2.1"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "1.3.3"

# Hotwire's SPA-like page accelerator [https://github.com/hotwired/turbo-rails]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://github.com/hotwired/stimulus-rails]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

gem "rack-cors"
gem "valid_url"

# Reduces boot times through caching; required in config/boot.rb
gem "acts_as_tenant"
gem "bootsnap", require: false
gem "draper"
gem "mimemagic", github: "mimemagicrb/mimemagic", ref: "01f92d86d15d85cfd0f20dabd025dcbd36a8a60f"
gem "pagy"
gem "rails-patterns"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "pg_search"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# devise gems
gem "devise"
gem "devise_invitable", "~> 2.0.7"
gem "devise-pwned_password"
gem "devise-jwt"

# Payments
gem "pay", "6.7.1"
gem "stripe", "~> 8.6"

gem "font-awesome-rails"
gem "attribute_normalizer"

gem "newrelic_rpm", "9.3.1"

group :development, :test do
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "listen", "~> 3.3"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "stackprof"
  gem "letter_opener"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", ">= 3.38"
  gem "selenium-webdriver"
end

gem "tailwindcss-rails"

# Database-backed Active Job backend [https://github.com/basecamp/solid_queue]
gem "solid_queue"

# A database-backed ActiveSupport::Cache::Store [https://github.com/rails/solid_cache]
gem "solid_cache"
