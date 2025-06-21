class Project < ApplicationRecord
  validates :name, :code, presence: true

  has_many :tasks

  has_rich_text :description

  def to_param
    return unless id
    code
  end
end
