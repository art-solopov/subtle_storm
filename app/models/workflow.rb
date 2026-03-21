# frozen_string_literal: true

class Workflow < ApplicationRecord
  belongs_to :project

  has_many :tasks, dependent: :restrict_with_exception
  has_mnay :statuses, dependent: :restrict_with_error

  enum :icon, { task: 'task', warning: 'warning' }, default: 'task', scopes: false
  enum :color, { blue: 'blue', gray: 'gray', yellow: 'yellow', red: 'red' }, default: 'gray', scopes: false
end
