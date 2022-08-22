source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"
gem "font-awesome-rails"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.2"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"
gem 'attribute_normalizer'
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"
gem "sassc-rails", "~> 2.1"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
gem "pg", "1.2.3"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
gem "stimulus_reflex", "= 3.5.0.pre8"
gem "hiredis"
gem "valid_url"
gem "image_processing", "~> 1.12"
gem "devise-jwt"
  gem 'jquery-ui-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.7"
gem "jsbundling-rails", "1.0.0"
gem "cssbundling-rails", "1.0.0"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
gem "sprockets-rails", "3.4.2"
gem "acts_as_tenant"
gem "aws-sdk-s3", "~> 1.87"
gem "draper"
gem "mimemagic", github: "mimemagicrb/mimemagic", ref: "01f92d86d15d85cfd0f20dabd025dcbd36a8a60f"
gem "newrelic_rpm"
gem "pagy"
gem "rails-patterns"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "rufo"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "pg_search"
gem "devise", github: "heartcombo/devise", branch: "main"
gem "devise-pwned_password"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "sinatra", ">= 1.3.0", require: nil
gem "byebug", platforms: %i[mri mingw x64_mingw]
gem "launchy"
gem "letter_opener"
gem "letter_opener_web"
gem "rexml"
gem "listen", "~> 3.3"
gem "spring"
gem "rack-mini-profiler", "~> 2.0"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "pay", "~> 3.0"

# To use Stripe, also include:
gem "stripe", ">= 5.0", "< 6.0"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use Sass to process CSS
# gem "sassc-rails", "~> 2.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  # Start debugger with binding.b [https://github.com/ruby/debug]
  gem "debug", ">= 1.0.0", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'rswag-specs'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", ">= 4.1.0"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler", ">= 2.3.3"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end


gem "hotwire-rails", "~> 0.1.3"

gem "cable_ready", "~> 5.0.pre8"
