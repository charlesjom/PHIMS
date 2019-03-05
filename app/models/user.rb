class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""
  
  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## User Details
  field :username, type: String
  field :_id, type: String, default: ->{ email.to_s.downcase }, overwrite: true

  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String

  ## User keypair
  field :encrypted_pri_key, type: String
  field :pub_key, type: String

	attr_accessor :tac_acceptance
  ## Records
  has_many :records

  before_validation(on: :create) do
    self.email = email.downcase
    self.id = email
  end

  validates_presence_of :email, :pub_key, :encrypted_pri_key
  validates_presence_of :first_name, :middle_name, :last_name, :username
  validates_presence_of :encrypted_pri_key, :pub_key
  validates_format_of :first_name, :middle_name, :last_name, with: /\A[\w ]+\z/i
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_uniqueness_of :email, :case_sensitive => false
end
