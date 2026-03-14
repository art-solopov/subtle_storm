# frozen_string_literal: true

module Warden
  module Strategies
    class Password < Base
      def valid?
        params['email_address'] || params['password']
      end

      def authenticate!
        user = User.authenticate_by(params.permit(:email_address, :password))
        user.nil? ? fail! : success!(user)
      end
    end
  end
end
