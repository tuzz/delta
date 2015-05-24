require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

ActiveRecord::Schema.define do
  create_table "models", force: true do
  end
end

class Model < ActiveRecord::Base
end
