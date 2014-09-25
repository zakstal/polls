class Poll < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :author_id, presence: true
end