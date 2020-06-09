class Api::V1::TweetsController < ApplicationController 
	def index
		authenticate_user
		if @current_user
			tweets = @current_user.tweets
			if !tweets.empty?
				render json: {tweets: tweets}, status: :ok
			else
				render json: {message: 'User has no tweets'}, status: :not_found
			end
		end
	end
end