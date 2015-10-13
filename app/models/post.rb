class Post < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, styles: { :original => "300x300"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 600 }
  validates :title, presence: true, length: { maximum: 140 }

  default_scope -> { order(created_at: :desc) }
end
