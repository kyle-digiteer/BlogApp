class Post < ApplicationRecord
  scope  :publish, -> { where("publish_date <= ?", Date.today)}
  scope  :is_active, ->  { where(is_active: true, is_featured: false)}
  scope  :is_featured, ->  { where(is_active: true, is_featured: true)}
end


