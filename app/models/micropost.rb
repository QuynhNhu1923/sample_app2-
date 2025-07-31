class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  IMAGE_FORMATS = %w(image/jpeg image/gif image/png).freeze

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {
                      in: IMAGE_FORMATS,
                      message: I18n.t(".image.format")
                    },
                    size: {
                      less_than: Settings.megabyte_5,
                      message: I18n.t(".image.size")
                    }

  scope :recent_posts, -> {order(created_at: :desc)}
  scope :relate_posts, lambda {|user_ids|
    where(user_id: user_ids).recent_posts
  }
end
