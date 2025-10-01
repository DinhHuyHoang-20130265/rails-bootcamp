class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Tweet", optional: true
  has_many :replies, class_name: "Tweet", foreign_key: "parent_id", dependent: :destroy
  validates :user, presence: true

  scope :top_level, -> { where(parent_id: nil) }
  scope :ordered_desc, -> { order(created_at: :desc) }

  # Pagination helpers
  scope :for_page, ->(page, per_page) { limit(per_page).offset((page - 1) * per_page) }

  def self.has_more_for?(base_scope, page:, per_page:)
    base_scope.count > (page * per_page)
  end
end
