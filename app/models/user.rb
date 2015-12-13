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

  def self.from_omniauth(auth)
    # Note that Facebook sometimes does not return email,
    # in that case you can use facebook-id@facebook.com as a workaround
    # email = auth[:info][:email] || "#{auth[:uid]}@facebook.com"
    email = "#{auth[:uid]}@facebook.com" # Always use fake email to avoid modify model to add provider field and other validations
    user = where(email: email).first_or_initialize

    # Set other properties on user here.
    user.name = auth[:info][:name]
    user.image_url = auth[:info][:image]

    # Finally, return user
    user.save(:validate => false) && user
  end
end
