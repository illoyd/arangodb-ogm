require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'Document', 'ogm/document'
  add_group 'Vertex', 'ogm/vertex'
  add_group 'Edge', 'ogm/edge'
end

# Include Rspec and related
require 'rspec'
require 'rspec/its'
require 'faker'

# Configure RSpec
RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.filter_gems_from_backtrace 'faraday', 'faraday_middleware', 'activesupport'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'arangodb/ogm'

# Require all helpers
Dir.glob('./spec/spec_support/**.rb').each { |file| require file }

# Configure ArangoDB connection URI
ENV['ARANGODB_URI'] ||= 'arangodb://localhost/arangodb_ogm_test'
