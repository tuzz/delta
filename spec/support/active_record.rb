require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  create_table "models", force: true do |t|
    t.string :species
    t.string :name
    t.string :type
  end
end

class Model < ActiveRecord::Base
  self.inheritance_column = nil

  def inspect
    %("Model: #{name}")
  end
end

Model.destroy_all
