# frozen_string_literal: true

class Workflow < ApplicationRecord
  belongs_to :project

  has_many :tasks, dependent: :restrict_with_exception
  has_many :task_statuses, dependent: :restrict_with_error
  accepts_nested_attributes_for :task_statuses, allow_destroy: true

  enum :icon, { task: 'task', warning: 'warning' }, default: 'task', scopes: false
  enum :color, { blue: 'blue', gray: 'gray', lime: 'lime', red: 'red', teal: 'teal' }, default: 'gray', scopes: false
end
