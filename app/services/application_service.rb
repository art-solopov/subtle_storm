# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :errors

  def perform
    # Override this
  end

  private

  def save(model)
    model.save.tap { @errors = model.errors }
  end
end
