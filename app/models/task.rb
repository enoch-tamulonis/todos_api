class Task < ApplicationRecord
  belongs_to :user
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
end
