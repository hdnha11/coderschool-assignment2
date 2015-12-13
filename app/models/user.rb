class User < ActiveRecord::Base
  has_secure_password

  has_many :incomming_messages, class_name: "Message", foreign_key: "recipient_id"
  has_many :outcomming_messages, class_name: "Message", foreign_key: "sender_id"

  has_many :friendables, :class_name => "Friendable", :foreign_key => "from_id"
  has_many :passive_friendables, :class_name => "Friendable", :foreign_key => "to_id"
  has_many :active_friends, -> { where(friendables: {accepted: true}) }, :through => :friendables, :source => :to
  has_many :passive_friends, -> { where(friendables: {accepted: true}) }, :through => :passive_friendables, :source => :from
  has_many :pending_friends, -> { where(friendables: {accepted: false}) }, :through => :friendables, :source => :to
  has_many :requested_friendables, -> { where(friendables: {accepted: false}) }, :through => :passive_friendables, :source => :from

  validates_uniqueness_of :email
  validates :name, presence: true
end
