class Task < ApplicationRecord
  belongs_to :project

  validates :number, :title, presence: true
  validates :number, numericality: { greater_than: 0 }

  has_rich_text :description
end
