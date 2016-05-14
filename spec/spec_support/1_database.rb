$strategy = ArangoDB::Test::Strategy.new(client: ArangoDB::Client.new, collections: %w(people))

RSpec.configure do |config|
  config.before(:suite) { $strategy.before_suite }
  config.before(:each)  { $strategy.before_spec }
  config.after(:each)   { $strategy.after_spec }
  config.after(:suite)  { $strategy.after_suite }
end
