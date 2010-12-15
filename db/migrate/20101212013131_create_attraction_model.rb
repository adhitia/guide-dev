class CreateAttractionModel < ActiveRecord::Migration
  def self.up
    create_table :attractions do |t|
      t.string :identity_url
      t.float :lat
      t.float :lng
      t.integer :popularity, :default => 1

      t.timestamps
    end

    add_column :tips, :street_address, :string, :default => ''
    add_column :tips, :attraction_id, :integer

    Address.all.each do |address|
      tip = Tip.find_by_id address.tip_id
      if tip.nil?
        next
      end
      if tip.calendar_id.nil?
        next # for heroku
      end

      if address.lat != 0
        a = Attraction.new
        a.identity_url = "placeholder_for_tip_#{tip.id}"
        a.lat = address.lat
        a.lng = address.lng
        a.save!

        tip.attraction_id = a.id
      end

      tip.street_address = address.address
      puts "!!!!!!!!!!!!!!!!!!!!!!! #{tip.inspect}"
      tip.save!
    end

#    Tip.all.each do |tip|
#      a = Attraction.new
#      a.identity_url = ''
#      a.lat = tip.address.lat
#      a.lng = tip.address.lng
#      a.save!
#
#      tip.attraction_id = a.id
#
#      tip.street_address = tip.address.address
#      tip.save
#    end

    rename_column :tips, :street_address, :address
  end

  def self.down
  end
end
