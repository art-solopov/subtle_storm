# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project
  belongs_to :status, class_name: 'TaskStatus'

  validates :number, :title, presence: true
  validates :number, numericality: { greater_than: 0 }
  validate :associations_should_have_same_project

  has_rich_text :description

  broadcasts_to ->(task) { [task.project, :tasks] }, template: 'tasks/_table_row'

  def to_param
    return full_number if association(:project).loaded?

    super
  end

  def full_number
    "#{project.code.upcase}-#{number}"
  end

  def self.find_by_full_number_or_id!(number_or_id)
    return find(number_or_id) if number_or_id.is_a?(Numeric) || number_or_id =~ /\A\d+\z/

    project_code, number = number_or_id.split('-')
    project = Project.find_by!(code: project_code.downcase)
    find_by!(project:, number:)
  end

  private

  def associations_should_have_same_project
    return if status&.project == project

    errors.add(:status, "Doesn't belong in the same project")
  end
end
