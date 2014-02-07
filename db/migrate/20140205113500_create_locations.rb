class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :city
      t.string :state_code
      t.string :climate
      t.string :employment_outlook
      t.integer :cost_of_living
      t.string :notes
    end
  end
end
