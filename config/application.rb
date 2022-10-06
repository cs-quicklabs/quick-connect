require_relative "boot"
require_relative "../lib/account_middleware"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kutumb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.middleware.use AccountMiddleware
    config.active_storage.variant_processor = :mini_magick
    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths << "#{Rails.root}/interactors"
    config.autoload_paths << "#{Rails.root}/presenters"
    config.swagger_dry_run = false
  end
end
