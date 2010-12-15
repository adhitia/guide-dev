class FillIdentityUrls < ActiveRecord::Migration
  def self.up
    Tip.all.each do |tip|
      tip.attraction.identity_url = "placeholder_for_tip_#{tip.id}"
      tip.attraction.save!
    end
  end

  def self.down
  end
end
