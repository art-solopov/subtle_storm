# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  belongs_to :workflow
  has_one :project, through: :workflow

  enum :category, { backlog: 100, analysis: 1000, development: 20_000, fulfillment: 60_000 }

  validates :name, presence: true, uniqueness: { scope: :workflow }
  validates :category, presence: true
  validate :associations_should_have_same_project

  scope :default_order, -> { order(:category, :name) }

  private

  def associations_should_have_same_project
    return if workflow.project == project

    errors.add(:workflow, "Doesn't belong in the same project")
  end
end
