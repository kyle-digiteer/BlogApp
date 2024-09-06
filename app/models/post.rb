class Post < ApplicationRecord
  belongs_to :user
  include ImageUploader::Attachment(:image)

  validates :title, presence: true
  validates :body, presence: true

  scope  :publish, -> { where('publish_date <= ?', Date.today) }
  scope  :is_active, -> { where(is_active: true, is_featured: false) }
  scope  :is_featured, -> { where(is_active: true, is_featured: true) }

  # check if the Post.user_id is equals to current_user_id
  # this method is use for checking if they can edit, delete it
  def belong_to_user(current_user_id)
    user_id == current_user_id
  end
end
