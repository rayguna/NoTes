class CreateTools < ActiveRecord::Migration[7.1]
  def change
    create_table :tools do |t|
      t.string :search_query
      t.json :results

      t.timestamps
    end
  end
end
