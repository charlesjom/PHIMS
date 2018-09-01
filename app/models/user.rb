class User
  include Mongoid::Document
  field :username, type: String
  field :email, type: String
  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :password_digest, type: String
  field :_id, type: String, default: ->{ email.to_s.downcase }, overwrite: true

  before_validation(on: :create) do
    self.email = email.downcase
    self.id = email
  end

  validates_presence_of :first_name, :middle_name, :last_name, :username, :email, :password
  validates_format_of :first_name, :middle_name, :last_name, with: /\A[\w ]+\z/i
	validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validates_uniqueness_of :email
  validates :email, uniqueness: { case_sensitive: false }
end
