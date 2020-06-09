class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	skip_before_action :verify_authenticity_token
	include Jwt
	def authenticate_user
		token = request.headers['x-auth']
		begin
			response = Jwt::JsonWebToken.decode(token)
			if !response.nil?
				@current_user = User.find(response[:user_id])
			else
				render json: {message: 'Invalid Token'}, status: :unauthorized
			end
	    rescue ActiveRecord::RecordNotFound => e
			render json: {message: 'Invalid Token'}, status: :unauthorized
		rescue JWT::DecodeError => e
			render json: {message: 'Invalid Token'}, status: :unauthorized
		end
	end

	private
	def get_token
		user = User.find_by email: params["email"]
		puts "user is #{user.inspect}"
		if user&.authenticate(params["password"])
			token = Jwt::JsonWebToken.encode(user_id: user.id) if user
			return {message: 'Authentication successfull', token: token}
		else 
			return {message: 'Authentication failure',errors: ['Invalid Email / Password']}
		end
	end
end