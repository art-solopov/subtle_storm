# frozen_string_literal: true

class TaskStatus < ApplicationRecord
  belongs_to :workflow
  has_one :project, through: :workflow

  has_many :from_transitions, class_name: 'TaskStatus::Transition', inverse_of: :from, dependent: :destroy
  has_many :to_transitions, class_name: 'TaskStatus::Transition', inverse_of: :to, dependent: :destroy
  has_many :next_statuses, class_name: 'TaskStatus', through: :from_transitions, source: :to

  enum :icon, %w[new achived done circle_dash hammer play tool].index_by(&:itself), default: 'new', scopes: false
  enum :color, %w[blue gray yellow green purple pink].index_by(&:itself), default: 'gray', scopes: false

  validates :name, presence: true, uniqueness: { scope: :workflow }

  scope :default_order, -> { order(:position, :name) }
end
