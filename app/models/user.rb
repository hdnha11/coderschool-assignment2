class User < ActiveRecord::Base
  has_secure_password

  has_many :incomming_messages, class_name: "Message", foreign_key: "recipient_id"
  has_many :outcomming_messages, class_name: "Message", foreign_key: "sender_id"

  validates_uniqueness_of :email
  validates :name, presence: true
end
