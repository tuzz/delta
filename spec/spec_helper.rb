require "rspec"
require "pry"
require "delta"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
end
