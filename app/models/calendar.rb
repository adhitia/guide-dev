class Calendar < ActiveRecord::Base
  has_many :conditions, :through => :guide_type
  has_many :tips, :order => 'day'
  belongs_to :user
  belongs_to :location
  belongs_to :guide_type
  accepts_nested_attributes_for :tips
  accepts_nested_attributes_for :location

  has_attached_file :image, :styles => { :medium => "300x300#", :thumb => "100x100#" },
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :path => "/:class/:attachment/:id/:style.:extension",
                    :default_style => :medium

  validates_presence_of :location_id, :guide_type_id, :user_id
  validates_length_of :name_location, :name_target, :in => 2..20,
                      :too_long => "no more than {{count}} characters expected",
                      :too_short => "at least {{count}} characters expected"

#  before_save :update_completed_percentage
  before_save {|guide| guide.name = guide.name_location + ' for ' + guide.name_target}

  def rating_num
    (rating * 100).round / 100.0
  end

  def rating_str
    if votes_num == 0
      "not rated"
    else
      "#{rating_num()}, #{votes_num} votes"
    end
  end

#  def errors_as_hash
#    result = {}
#    result[:calendar_name_location] = errors.on(:name_location) if !errors.on(:name_location).blank?
#    result[:calendar_name_target] = errors.on(:name_target) if !errors.on(:name_target).blank?
#    result[:location_name] = errors.on(:location_id) if !errors.on(:location_id).blank?
#    result
#  end

  def update_completed_percentage
    completed = 0
    total = conditions.size * DAY_LIMIT #Weekday.all.size
    tips(true).each do |tip|
      if tip.description.blank?
        completed += 0.5
      else
        completed += 1
      end
    end
    self.completed_percentage = (completed * 100.0 / total).round

    # can be more than one tip at a single spot
    if self.completed_percentage > 100
      self.completed_percentage = 100
    end
  end

  def update_rating
    if votes_num == 0
      self.rating = 0
    else
      self.rating = Float(votes_sum) / votes_num
    end
  end


  def grouped_tips
    groups = []
    current_day = -1
    current_condition = -1

    tips.each do |tip|
      if tip.day != current_day
        if groups.size == DAY_LIMIT
          break
        end
        # TODO handle somehow case of gaps in 'day' sequence
        groups.push Hash.new
        current_day = tip.day

        conditions.each do |condition|
          groups.last[condition.id] = []
        end
      end

      groups.last[tip.condition_id].push tip
    end

    # empty day
    if groups.size < DAY_LIMIT
      groups.push Hash.new
      conditions.each do |condition|
        groups.last[condition.id] = []
      end
    end

    groups.each do |group|
      group.each_value do |group2|
        group2.sort! {|tip1, tip2| tip1.rank <=> tip2.rank }
      end
    end

    groups
  end
end