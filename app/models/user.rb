class User < ActiveRecord::Base
  include Encryption::AttrEncrypted
  include Clearance::User

  attr_encrypted  :username, :email, :first_name, :last_name
  attr_accessible :username, :email, :first_name, :last_name, :is_system, :is_admin, :is_sales, :is_merchant, :password, :password_confirmation, :active

  has_one :merchant
  has_many :offers
  #
  # AR uniqueness validation runs a DB query. Since email is stored as encrypted_email,
  # we can't validate uniqueness of email directly. However, *since the mapping of the
  # of the plaintext and encrypted values is one-to-one*, we can validate  uniqueness
  # of the encrypted value instead.
  #
  validates_uniqueness_of :encrypted_email, :encrypted_username
  validates :password, presence: true, on: :create
  validates :password, confirmation: true, length: { minimum: 8, maximum: 15 }, password: true, on: :create
  validates :password, confirmation: true, length: { minimum: 8, maximum: 15 }, password: true, allow_blank: true,  on: :update
  validates :email, email: true
  validates_presence_of :username, :first_name, :last_name, :email
  validate :validate_has_role

  def self.authenticate(login, password)
    if user = (find_by_username(login) || find_by_email(login.to_s.downcase))
      if user.active? && user.authenticated?(password)
        return user
      end
    end
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def validate_has_role
    errors.add(:base, "Must select a role") unless has_role?
  end

  def has_role?
    is_system? || is_admin? || is_sales? || is_merchant?
  end

  def only_has_merchant_role?
    is_merchant? && !is_admin? && !is_sales? && !is_system
  end

end
