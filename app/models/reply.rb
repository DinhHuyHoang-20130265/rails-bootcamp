class Reply < Tweet
  belongs_to :parent, class_name: "Tweet", optional: true
  validates :content, presence: true
end
