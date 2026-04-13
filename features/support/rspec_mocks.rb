# features/support/rspec_mocks.rb
#
# Enables RSpec::Mocks inside Cucumber step definitions.
# This is needed so that `allow(...)` / `expect(...).to have_received()` work
# in feature tests that stub external APIs (e.g. SendGrid).

require 'rspec/mocks'
require 'rspec/expectations'

# Expose `double`, `allow`, and `expect` in cucumber step definitions.
World(RSpec::Mocks::ExampleMethods)
World(RSpec::Matchers)

Around do |_scenario, block|
  RSpec::Mocks.setup
  begin
    block.call
  ensure
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
