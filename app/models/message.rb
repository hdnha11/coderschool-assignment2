class Message < ActiveRecord::Base
  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"

  validates :content, presence: true
  validates :recipient, presence: true
  validates :sender, presence: true
end
