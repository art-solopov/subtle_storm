# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  belongs_to :project

  enum :category, { backlog: 100, analysis: 1000, development: 20_000, fulfillment: 60_000 }

  validates :name, presence: true, uniqueness: { scope: :project }
  validates :category, presence: true

  scope :default_order, -> { order(:category, :name) }
end
