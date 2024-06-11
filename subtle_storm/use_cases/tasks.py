from .. import repo
from ..forms import Task


def create(form: Task, projects_repo: repo.ProjectsRepository, tasks_repo: repo.TasksRepository):
    project = form.project
    number = projects_repo.increase_task_counter(project)
    data = {**dict(form), 'number': number}
    tasks_repo.insert(data)
