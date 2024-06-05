import logging

from fastapi import FastAPI, Request, Depends
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from typing import Annotated

from . import db as adb
from .repo import ProjectsRepository, TasksRepository

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
def projects_list(request: Request):
    repo = ProjectsRepository(db)
    return repo.index()


@app.get('/api/tasks')
def tasks_list(request: Request, project: str):
    # TODO: query params processing in use case?
    query_params = dict(project=f'projects/{project.lower()}')
    tasks_repo = TasksRepository(db)
    return tasks_repo.index(query_params)
