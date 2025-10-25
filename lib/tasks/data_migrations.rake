# frozen_string_literal: true

namespace :data_migrations do
  desc 'Set initial status for tasks'
  task set_initial_status_for_tasks: :environment do
    Task.includes(project: :task_statuses).in_batches do |tasks|
      projects = Project.where(id: tasks.pluck(:project_id))
      statuses = TaskStatus.backlog.where(project: projects).group_by(&:project)

      tasks.each do |task|
        task.update!(status: statuses[task.project].first)
      end
    end
  end
end
