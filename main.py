import logging

from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates

import db as adb
from repo import ProjectsRepository

logging.basicConfig(level=logging.DEBUG)

app = FastAPI(debug=True)
db = adb.ArangoConnection().db
templates = Jinja2Templates(directory='templates')


@app.get('/')
async def root(request: Request):
    return templates.TemplateResponse(request=request, name='root.html')


@app.get('/projects')
def projects_list(request: Request):
    repo = ProjectsRepository(db)
    projects = repo.index()
    return templates.TemplateResponse(request=request, name='projects_index.html',
                                      context={'projects': projects})
