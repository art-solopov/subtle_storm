import logging

from fastapi import FastAPI
from fastapi.responses import PlainTextResponse

import db as adb
from repo import ProjectsRepository

app = FastAPI(debug=True)
logging.basicConfig(level=logging.DEBUG)

db = adb.ArangoConnection().db


@app.get('/', response_class=PlainTextResponse)
async def root():
    return "Hello world"


@app.get('/projects')
def projects_list():
    repo = ProjectsRepository(db)
    projects = repo.index()
    return projects
