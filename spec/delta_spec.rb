require "spec_helper"

RSpec.describe Delta do
  context "plain objects" do
    let(:klass) { Pokemon }

    let(:pikachu)    { Pokemon.new("Pikachu",    "Zappy",    "Electric") }
    let(:pidgey)     { Pokemon.new("Pidgey",     "Mr. Peck", "Flying")   }
    let(:magikarp)   { Pokemon.new("Magikarp",   "Splashy",  "Water")    }
    let(:raichu)     { Pokemon.new("Raichu",     "Zappy",    "Electric") }
    let(:butterfree) { Pokemon.new("Butterfree", "Flappy",   "Flying")   }

    let(:from) { [pikachu, pidgey, magikarp].to_enum  }
    let(:to)   { [raichu, pidgey, butterfree].to_enum }

    include_examples "integration specs"
  end

  context "active record objects" do
    let(:klass) { Model }

    let!(:pikachu)    { Model.create!(species: "Pikachu", name: "Zappy", type: "Electric")   }
    let!(:pidgey)     { Model.create!(species: "Pidgey", name: "Mr. Peck", type: "Flying")   }
    let!(:magikarp)   { Model.create!(species: "Magikarp", name: "Splashy", type: "Water")   }
    let!(:raichu)     { Model.create!(species: "Raichu", name: "Zappy", type: "Electric")    }
    let!(:butterfree) { Model.create!(species: "Butterfree", name: "Flappy", type: "Flying") }

    after { Model.destroy_all }

    let(:from) { Model.where(species: %w(Pikachu Pidgey Magikarp)) }
    let(:to) { Model.where(species: %w(Raichu Pidgey Butterfree)) }

    include_examples "integration specs"
  end
end
