require_relative "boot"

require "csv"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SoccerField
  class Application < Rails::Application
    config.load_defaults 6.0
    config.autoload_paths << Rails.root.join('assets')
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**",
                                "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.time_zone = "Asia/Bangkok"
    config.active_record.default_timezone = :local
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.autoload_paths << Rails.root.join('assets')
  end
end
