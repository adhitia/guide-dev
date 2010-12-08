class Book < ActiveRecord::Base
  BOOK_HEIGHT = 300
  BOOK_WIDTH = 600
  BOOK_PROPORTION = BOOK_WIDTH * 1.0 / BOOK_HEIGHT

  belongs_to :calendar
  has_many :book_tips, :dependent => :destroy, :order => :rank

  def sync_tips
    calendar.tips.each do |tip|
      if !book_tips.exists?(:tip_id => tip.id)
        puts "creating a book tip #{book_tips.size}"
        book_tips.create(:tip_id => tip.id, :rank => book_tips.size)
      end
    end
  end
end
