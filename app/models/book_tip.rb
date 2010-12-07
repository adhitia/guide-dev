class BookTip < ActiveRecord::Base
  belongs_to :book
  belongs_to :tip

#  validates_presence_of tip_id, book_id
end
