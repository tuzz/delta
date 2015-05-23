require "rspec"
require "pry"
require "delta"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = :doc
end

class Pokemon
  attr_reader :species, :name, :level, :type

  def initialize(species, name, level, type)
    @species = species
    @name = name
    @level = level
    @type = type
  end
end

