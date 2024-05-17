import logging

from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles

from . import db as adb
from .repo import ProjectsRepository, TasksRepository

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(debug=True)
db = adb.ArangoConnection().db
templates = Jinja2Templates(directory='templates')


app.mount("/static", StaticFiles(directory="static"))


@app.get('/')
async def root(request: Request):
    return templates.TemplateResponse(request=request, name='root.html')


@app.get('/projects')
def projects_list(request: Request):
    repo = ProjectsRepository(db)
    projects = repo.index()
    return templates.TemplateResponse(request=request, name='projects_index.html',
                                      context={'projects': projects})


@app.get('/tasks')
def tasks_list(request: Request, project: str):
    # TODO: query params processing in use case?
    query_params = dict(project=f'projects/{project.lower()}')
    projects_repo = ProjectsRepository(db)
    tasks_repo = TasksRepository(db)
    project = projects_repo.show(project.lower())
    all_projects = projects_repo.index()
    tasks = tasks_repo.index(query_params)
    return templates.TemplateResponse(
        request=request, name='tasks_index.html',
        context={'tasks': tasks, 'project': project, 'all_projects': all_projects}
        )
