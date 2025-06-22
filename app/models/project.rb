class Project < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, exclusion: { in: %w[new] }, uniqueness: true

  has_many :tasks

  has_rich_text :description

  before_validation :lowercase_code

  def to_param
    return unless id
    code
  end

  private

  def lowercase_code
    return if code.blank?

    self.code = self.code.downcase
  end
end
