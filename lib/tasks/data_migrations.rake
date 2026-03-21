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

  desc 'Create initial workflows for projects'
  task create_initial_workflows: :environment do
    Project.find_each do |project|
      Projects::CreateDefaults.create_default_workflow(project)
    end
  end

  desc 'Set workflows for statuses'
  task set_default_task_status_workflows: :create_initial_workflows do
    TaskStatus.includes(project: :workflows).find_each do |ts|
      ts.workflow = ts.project.workflows.first
      ts.save!
    end
  end

  desc 'Set workflows for tasks'
  task set_default_task_workflows: %i[create_initial_workflows set_default_task_status_workflows] do
    Task.includes(project: :workflows).find_each do |task|
      task.workflow = task.project.workflows.first
      task.save!
    end
  end
end
