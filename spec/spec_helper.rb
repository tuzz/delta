require "rspec"
require "support/shared_examples"
require "support/active_record"
require "pry"
require "delta"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
end

class Pokemon
  attr_accessor :species, :name, :type

  def initialize(species, name, type)
    self.species = species
    self.name = name
    self.type = type
  end
end
