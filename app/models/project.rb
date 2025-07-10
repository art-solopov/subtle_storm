# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, exclusion: { in: %w[new] }, uniqueness: true

  has_many :tasks, dependent: :restrict_with_exception

  has_rich_text :description

  normalizes :code, with: ->(code) { code.strip.downcase }

  def to_param
    return unless id

    code
  end
end
