class FavoritesController < ApplicationController
     before_action :logged_in_user
    
    def create
        @micropost = Micropost.find(params[:micropost_id])
        current_user.favorite(@micropost)
        respond_to do |format|
            format.html { redirect_to request.referrer || root_url }
            format.js
        end
    end
    
    def destroy
        @micropost = Micropost.find(params[:micropost_id])
        current_user.cancel_favorite(@micropost)
        respond_to do |format|
            format.html { redirect_to request.referrer || root_url }
            format.js
        end        
    end
    
end
