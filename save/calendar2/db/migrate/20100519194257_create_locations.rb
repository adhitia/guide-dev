class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    Location.create(:name => 'Rio de Janeiro, Brazil', :code => 'BRXX0201')
  end

  def self.down
    drop_table :locations
  end
end
