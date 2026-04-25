# frozen_string_literal: true

class TaskStatus
  class Transition < ApplicationRecord
    self.table_name = 'task_status_transitions'

    belongs_to :from, class_name: '::TaskStatus'
    belongs_to :to, class_name: '::TaskStatus'
  end
end
