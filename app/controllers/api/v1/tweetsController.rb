class Api::V1::TweetsController < ApplicationController 
	before_action :tweet_params, only: [:create]
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

	def create
		authenticate_user
		puts "current_user #{@current_user.inspect}"
		if !@current_user.nil?
			tweet = @current_user.tweets.create(tweet_params)
			render json: {message: 'Tweet created successfully', tweet: tweet}, status: :created
		end		
	end

	def destroy
		authenticate_user
		if !@current_user.nil?		
			begin
				tweet = @current_user.tweets.find params['id']
				if tweet && tweet.destroy
					render json: {message: 'Tweet Deleted successfully'}, status: :ok
				end
			rescue 
				render json: {message: 'Invalid tweet id'}, status: :not_found
			end
		end
	end

	private
	
	def tweet_params
		params.require(:tweet).permit(:description)
	end
end