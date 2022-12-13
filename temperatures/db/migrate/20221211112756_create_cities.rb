class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.string  :slug, limit: 50, null: false
      t.index :slug, unique: true

      t.decimal :latitude,  precision: 10, scale: 6,  null: false
      t.decimal :longitude, precision: 10, scale: 6,  null: false

      t.timestamps
    end
  end
end
