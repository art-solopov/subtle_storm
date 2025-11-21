# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Model
  include ActiveModel::Attributes

  define_model_callbacks :perform
  define_model_callbacks :success, only: [:after]
  define_model_callbacks :failure, only: [:after]

  @prepend_methods = Module.new do
    def perform(...)
      status = run_callbacks :perform do
        super(...)
      end

      if status
        run_callbacks :success
      else
        run_callbacks :failure
      end

      status
    end
  end

  def self.inherited(subclass)
    super
    subclass.prepend @prepend_methods
  end

  before_perform do
    if invalid?
      logger.debug 'Validation failed'
      throw :abort
    end
  end

  def perform
    # Override this
  end

  private

  def save(model)
    model.save.tap { @errors = model.errors }
  end

  def logger
    @logger ||= ActiveSupport::TaggedLogging.new(Rails.logger).tagged(self.class.name)
  end
end
