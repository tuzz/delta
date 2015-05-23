require "rspec"
require "pry"
require "delta"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
end

class Pokemon
  attr_accessor :species, :name, :level, :type

  def initialize(species, name, type)
    self.species = species
    self.name = name
    self.type = type
  end
end
