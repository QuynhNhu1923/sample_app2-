class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_create :downcase_email
  before_create :create_activation_digest

  has_secure_password

  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MIN_PASSWORD_LENGTH = 6
  MAX_BIRTHDAY_YEARS_AGO = 100
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  USER_PERMIT = %i(name email password gender birthday).freeze
  enum gender: {male: 0, female: 1, other: 2}

  before_save {self.email = email.downcase}
  before_validation :normalize_gender
  # Validate that name is present and does not exceed MAX_NAME_LENGTH
  validates :name, presence: true, length: {maximum: MAX_NAME_LENGTH}
  # Validate that email:
  # - is present
  # - does not exceed MAX_EMAIL_LENGTH
  # - matches the required email format (VALID_EMAIL_REGEX)
  # - is unique in the database
  validates :email, presence: true, length: {maximum: MAX_EMAIL_LENGTH},
                    format: {with: VALID_EMAIL_REGEX, message: :invalid},
                    uniqueness: true
  # Validate that password is present and has at least
  #                     MIN_PASSWORD_LENGTH characters
  validates :password, presence: true, length: {minimum: MIN_PASSWORD_LENGTH},
allow_nil: true
  # Validate that gender is present and included in the list of valid genders
  validates :gender, presence: true, inclusion: {in: Settings.genders}
  # Validate that birthday is present
  validates :birthday, presence: true
  # Custom validation to ensure birthday is within a valid age range
  #                       (defined in method `birthday_within_range`)
  validate :birthday_within_range

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_column(:remember_digest, nil)
  end

  # def authenticated? remember_token
  #   return false if remember_digest.nil?

  #   BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest") # Dynamically access digest
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Returns the user's full name.
  def full_name
    name
  end

  # Returns the user's age in years.
  def age
    return nil if birthday.nil?

    ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor
  end

  private
  def birthday_within_range
    return if birthday.blank?

    # Check if birthday is in the future
    errors.add(:birthday, :in_future) if birthday > Date.current
    # Check if birthday is more than 100 years ago
    return unless birthday < MAX_BIRTHDAY_YEARS_AGO.years.ago.to_date

    errors.add(:birthday, :too_old, count: MAX_BIRTHDAY_YEARS_AGO)
  end

  def normalize_gender
    self.gender = gender.is_a?(String) ? gender.downcase : gender.to_s.downcase
    self.gender = nil unless Settings.genders.include?(gender)
  end

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
