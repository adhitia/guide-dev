class Book < ActiveRecord::Base
  BOOK_HEIGHT = 300
  BOOK_WIDTH = 600
  BOOK_PROPORTION = BOOK_WIDTH * 1.0 / BOOK_HEIGHT

  belongs_to :calendar

  serialize :image_data, ::HashWithIndifferentAccess
end
