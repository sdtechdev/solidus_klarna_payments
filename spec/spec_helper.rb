# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

# Run Coverage report
require 'solidus_dev_support/rspec/coverage'

require File.expand_path('dummy/config/environment.rb', __dir__).tap { |file|
  # Create the dummy app if it's still missing.
  system 'bin/rake extension:test_app' unless File.exist? file
}

# Requires factories and other useful helpers defined in spree_core.
require 'solidus_dev_support/rspec/feature_helper'
require 'spree/testing_support/order_walkthrough'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Will load Solidus core factory first and then the ones
# defined in `lib/solidus_klarna_payments/testing_support/factories.rb`.
# and `lib/solidus_klarna_payments/testing_support/factories`.
SolidusDevSupport::TestingSupport::Factories.load_for(SolidusKlarnaPayments::Engine)

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
  if defined?(ActiveStorage::Current)
    config.before(:all) do
      ActiveStorage::Current.host = 'http://www.example.com'
    end
  end
end
