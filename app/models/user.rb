class User < ApplicationRecord
  has_secure_password

  MAX_NAME_LENGTH = 50
  MAX_EMAIL_LENGTH = 255
  MIN_PASSWORD_LENGTH = 6
  MAX_BIRTHDAY_YEARS_AGO = 100
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  USER_PERMIT = %i(name email password gender birthday).freeze
  enum gender: {male: 0, female: 1, other: 2}

  before_save {self.email = email.downcase}

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
  validates :password, presence: true, length: {minimum: MIN_PASSWORD_LENGTH}
  # Validate that gender is present and included in the list of valid genders
  validates :gender, presence: true, inclusion: {in: Settings.genders}
  # Validate that birthday is present
  validates :birthday, presence: true
  # Custom validation to ensure birthday is within a valid age range
  #                       (defined in method `birthday_within_range`)
  validate :birthday_within_range

  private
  def birthday_within_range
    return if birthday.blank?

    # Check if birthday is in the future
    errors.add(:birthday, :in_future) if birthday > Date.current
    # Check if birthday is more than 100 years ago
    return unless birthday < MAX_BIRTHDAY_YEARS_AGO.years.ago.to_date

    errors.add(:birthday, :too_old, count: MAX_BIRTHDAY_YEARS_AGO)
  end
end
