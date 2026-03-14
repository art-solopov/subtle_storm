# frozen_string_literal: true

module Warden
  module Mixins
    module Common
      module Overrides
        def params
          ActionController::Parameters.new(super)
        end

        def request
          ActionDispatch::Request.new(@env)
        end

        def session
          super.with_indifferent_access
        end
      end

      prepend Overrides
    end
  end
end
