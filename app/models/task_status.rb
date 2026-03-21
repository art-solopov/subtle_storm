# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  belongs_to :project
  belongs_to :workflow

  enum :category, { backlog: 100, analysis: 1000, development: 20_000, fulfillment: 60_000 }

  validates :name, presence: true, uniqueness: { scope: :project }
  validates :category, presence: true
  validate :associations_should_have_same_project

  scope :default_order, -> { order(:category, :name) }

  private

  def associations_should_have_same_project
    return if workflow.project == project

    errors.add(:workflow, "Doesn't belong in the same project")
  end
end
