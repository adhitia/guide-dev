class CreateWeatherForecasts < ActiveRecord::Migration
  def self.up
    create_table :weather_forecasts do |t|
      t.datetime :last_checked
      t.integer :location_id

      t.timestamps
    end

    last_checked = DateTime.now - 1
    Location.find(:all).each do |l|
      WeatherForecast.create(:location_id => l.id, :last_checked => last_checked, :updated_at => last_checked)
    end
  end

  def self.down
    drop_table :weather_forecasts
  end
end
