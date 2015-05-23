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
    @species = species
    @name = name
    @type = type
  end
end
