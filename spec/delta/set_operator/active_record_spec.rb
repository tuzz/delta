require "spec_helper"

RSpec.describe Delta::SetOperator::ActiveRecord do
  let!(:pikachu)    { Model.create!(species: "Pikachu", name: "Zappy", type: "Electric")   }
  let!(:pidgey)     { Model.create!(species: "Pidgey", name: "Mr. Peck", type: "Flying")   }
  let!(:magikarp)   { Model.create!(species: "Magikarp", name: "Splashy", type: "Water")   }
  let!(:raichu)     { Model.create!(species: "Raichu", name: "Zappy", type: "Electric")    }
  let!(:butterfree) { Model.create!(species: "Butterfree", name: "Flappy", type: "Flying") }

  after { Model.destroy_all }

  let(:a) { Model.where(species: %w(Pikachu Pidgey Magikarp)) }
  let(:b) { Model.where(species: %w(Raichu Pidgey Butterfree)) }

  it_behaves_like "a set operator"
end
