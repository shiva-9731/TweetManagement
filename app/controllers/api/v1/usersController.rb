class Api::V1::UsersController < ApplicationController
	
	def index
		authenticate_user
		if @current_user
			@users = User.all
			render json: @users, status: :ok
		end
	end

	def sign_in
		token_obj = get_token
		puts "token : #{token_obj}"
		if token_obj[:token] && (!token_obj.has_key?"errors")
			redis = Redis.new(host: "localhost", post: 6379)
			redis.hset('user_data', 'token', token_obj[:token])
			render json: token_obj, status: :ok			
		else
			render json: token_obj, status: :not_found			
		end
	end

	def destroy
		authenticate_user
		if @current_user
			redis = Redis.new(host: "localhost", post: 6379)
			token = redis.hget('user_data', 'token')
			if token.present?
				redis.hset('user_data','token','')
				render json: {message: 'Successfully logged out'}, status: :ok			
			else
				render json: {message: 'Invalid Token'}, status: :unauthorized	
			end
		end
	end
end