# frozen_string_literal: true


module WorkflowsHelper
  def workflow_display(workflow, **)
    render Workflows::DisplayViewModel.new(workflow, **)
  end
end
