import logging

from fastapi import FastAPI, Request, Response, Depends
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from starlette.status import HTTP_204_NO_CONTENT
from typing import Annotated

from . import db as adb
from .repo import ProjectsRepository, TasksRepository
from .forms import Task as TaskForm
from .use_cases import tasks as use_cases_tasks

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(debug=True)
db = adb.ArangoConnection().db
templates = Jinja2Templates(directory='templates')


app.mount("/static", StaticFiles(directory="static"))


def _render_base_template(request: Request, component: str, current_project: str | None):
    return templates.TemplateResponse(
        request=request,
        name='root.html',
        context={'current_project': current_project, 'component': component}
        )


def load_project(project: str):
    projects_repo = ProjectsRepository(db)
    return projects_repo.show(project.lower())


ProjectDep = Annotated[ProjectsRepository.DTO, Depends(load_project)]


@app.get('/')
async def root(request: Request):
    return _render_base_template(request, 'Home', None)


@app.get('/tasks')
async def tasks_view(request: Request, project: str):
    return _render_base_template(request, 'TasksTable', project)


@app.get('/api/projects')
def projects_list():
    repo = ProjectsRepository(db)
    return repo.index()


@app.get('/api/projects/{key}')
def project_show(key: str):
    repo = ProjectsRepository(db)
    return repo.show(key.lower())


@app.get('/api/tasks')
def tasks_list(project: str):
    query_params = dict(project=project.lower())
    tasks_repo = TasksRepository(db)
    return tasks_repo.index(query_params)


@app.post('/api/tasks', response_class=Response, status_code=HTTP_204_NO_CONTENT)
def task_create(task: TaskForm):
    projects_repo = ProjectsRepository(db)
    tasks_repo = TasksRepository(db)
    use_cases_tasks.create(task, projects_repo=projects_repo, tasks_repo=tasks_repo)
