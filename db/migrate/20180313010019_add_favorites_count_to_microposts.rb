class AddFavoritesCountToMicroposts < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :favorites_count, :integer, : default => 0
  end
end