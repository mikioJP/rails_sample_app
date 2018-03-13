class Favorite < ApplicationRecord
    belongs_to :user, class_name: "User"
    belongs_to :micropost, class_name: "Micropost", counter_cache: :favorites_count
    validates :user_id, presence: true
    validates :micropost_id, presence: true
    
end
