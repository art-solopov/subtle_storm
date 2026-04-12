# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  belongs_to :workflow
  has_one :project, through: :workflow

  enum :icon, %w[new achived done circle_dash hammer play tool].index_by(&:itself), default: 'new', scopes: false
  enum :color, %w[blue gray yellow green purple pink].index_by(&:itself), default: 'gray', scopes: false

  validates :name, presence: true, uniqueness: { scope: :workflow }

  scope :default_order, -> { order(:position, :name) }
end
