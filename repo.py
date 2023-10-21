import arango


class Base:
    def __init__(self, adb: arango.database.Database):
        self.adb = adb


class ProjectsRepository(Base):
    def index(self):
        return self.adb.collection('projects').all()
