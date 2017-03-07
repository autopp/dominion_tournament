require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DominionTournament
  class Application < Rails::Application
    config.generators do |g|
      g.orm :active_record
      g.assets false
      g.helper false
      g.test_framework :rspec,
                       view_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       helper_specs: false,
                       integration_tool: false
    end
  end
end
