# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, exclusion: { in: %w[new] }, uniqueness: true, format: { with: /\A[a-z]{2,}\z/ }

  has_many :tasks, dependent: :restrict_with_exception

  has_rich_text :description

  normalizes :code, with: ->(code) { code.strip.downcase.gsub(/\W+/, '') }

  after_commit :create_tasks_number_sequence, on: :create
  after_destroy_commit :drop_tasks_number_sequence

  def to_param
    return unless id

    code
  end

  def tasks_number_sequence_name
    "_seq_projects__#{code}_tasks_number"
  end

  def next_task_number
    result = self.class.connection.exec_query "SELECT NEXT VALUE FOR #{tasks_number_sequence_name} AS task_number"
    raise "Expected one result, got #{result.count}" unless result.one?

    result.first['task_number']
  end

  private

  def create_tasks_number_sequence
    self.class.connection.execute "CREATE SEQUENCE IF NOT EXISTS #{tasks_number_sequence_name} AS INT UNSIGNED"
  end

  def drop_tasks_number_sequence
    self.class.connection.execute "DROP SEQUENCE IF EXISTS #{tasks_number_sequence_name}"
  end
end
