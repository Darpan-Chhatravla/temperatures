class CreateTemperatures < ActiveRecord::Migration[7.0]
  def change
    create_table :temperatures do |t|
      t.references :city

      t.date    :temp_date,      null: false
      t.integer :min_forecasted, null: false
      t.integer :max_forecasted, null: false

      t.timestamps
    end

    add_index :temperatures, [:city_id, :temp_date], unique: true
  end
end
