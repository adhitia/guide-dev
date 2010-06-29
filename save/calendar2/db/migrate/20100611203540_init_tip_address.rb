class InitTipAddress < ActiveRecord::Migration
  def self.up
    Tip.all.each do |tip|
      address = Address.create :address => '', :lat => nil, :lng => nil, :location_id => tip.calendar.location_id, :tip_id => tip.id
      tip.address_id = address.id
      tip.save
    end
  end

  def self.down
  end
end
