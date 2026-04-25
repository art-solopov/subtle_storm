# frozen_string_literal: true

class Workflow < ApplicationRecord
  belongs_to :project

  has_many :tasks, dependent: :restrict_with_exception
  has_many :task_statuses, dependent: :restrict_with_error
  accepts_nested_attributes_for :task_statuses, allow_destroy: true
  belongs_to :default_status, class_name: 'TaskStatus', optional: true

  enum :icon, { task: 'task', warning: 'warning' }, default: 'task', scopes: false
  enum :color, { blue: 'blue', gray: 'gray', lime: 'lime', red: 'red', teal: 'teal' }, default: 'gray', scopes: false

  validate :should_own_default_status

  private

  def should_own_default_status
    return if default_status.nil?

    errors.add(:default_status, 'Should own default status') unless default_status.id.in?(task_status_ids)
  end
end
