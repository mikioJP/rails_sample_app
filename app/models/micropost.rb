class Micropost < ApplicationRecord
  
  belongs_to :user
  has_many :users, through: :passive_favorites           
  has_many :passive_favorites, class_name: "Favorite",
                              foreign_key: "micropost_id",
                              dependent: :destroy
                              
  
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size
  
  def favorited?(current_user)
      passive_favorites.exists?(user_id: current_user.id)
  end
  
  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
