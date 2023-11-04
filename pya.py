from quart import Quart, render_template
from quart.utils import run_sync

from db import ArangoConnection
from repo import ProjectsRepository

app = Quart(__name__)
arango = ArangoConnection()


@app.route("/")
async def root():
    return await render_template('root.html')


@app.route("/projects")
async def projects_index():
    repo = ProjectsRepository(arango.db)
    projects = await run_sync(repo.index)()
    return await render_template('projects_index.html', projects=projects)


@app.route("/projects/<key>")
async def projects_show():
    project_repo = ProjectsRepository(arango.db)


if __name__ == "__main__":
    app.run(debug=True)
