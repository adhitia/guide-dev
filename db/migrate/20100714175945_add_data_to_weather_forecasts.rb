class AddDataToWeatherForecasts < ActiveRecord::Migration
  def self.up
    add_column :weather_forecasts, :data, :string, :limit => 1000
    add_index
  end

  def self.down
    remove_column :weather_forecasts, :data
  end
end
