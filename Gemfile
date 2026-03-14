source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby version app is using, [https://www.ruby-lang.org/en/downloads/]
ruby "4.0.0"

# Bundle edge Rails instead: gem 'rails', [https://github.com/rails/rails]
gem "rails", "8.1.1"

# The asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

gem "sqlite3"

# Use Puma as the app server [https://github.com/puma/puma]
gem "puma"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

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
gem "rails-patterns"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# devise gems
gem "devise"
gem "devise_invitable"

# Payments
gem "pagy", "8.4.0"
gem "pay", "6.7.1"
gem "stripe", "~> 8.6"

gem "font-awesome-rails"

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "listen", "~> 3.3"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "memory_profiler"
  gem "rack-mini-profiler", require: false
  gem "stackprof"
  gem "letter_opener"
  gem "csv"

  gem "debug", ">= 1.0.0", platforms: %i[ mri mingw x64_mingw ]

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "derailed_benchmarks"
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

