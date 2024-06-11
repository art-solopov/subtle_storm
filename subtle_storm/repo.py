from typing import Any, Dict
from enum import Enum

from pydantic import BaseModel, Field, computed_field

import arango


class ArangoDTO(BaseModel):
    key: str = Field(alias='_key')
    id: str = Field(alias='_id')
    rev: str = Field(alias='_rev')


class Base:
    def __init__(self, adb: arango.database.Database):
        self.adb = adb


class ProjectsRepository(Base):
    class DTO(ArangoDTO):
        name: str

        @property
        def code(self):
            return self.arango_data.key

    def index(self):
        return [self.DTO(**d) for d in self._collection.all()]

    def show(self, key):
        data = self._collection.get(key)
        if data is None:
            return None

        return self.DTO(**data)

    def increase_task_counter(self, key):
        aql = '''
        LET p = FIRST(FOR p IN projects FILTER p._key == @key RETURN p)
        UPDATE p WITH {_taskCount: p._taskCount + 1} IN projects
        RETURN NEW._taskCount
        '''
        data = self.adb.aql.execute(aql, bind_vars={'key': key})
        return next(data)

    @property
    def _collection(self):
        return self.adb.collection('projects')


class StatusRepository(Base):
    class DTO(ArangoDTO):
        project: str
        name: str
        position: int


class TasksRepository(Base):
    class SortFields(str, Enum):
        title = 'title'

    class DTO(ArangoDTO):
        project: str
        number: int
        title: str
        description: str | None = None

    class IndexDTO(DTO):
        status: StatusRepository.DTO

    def index(self, query_params: Dict[str, Any]):
        filters = ' AND '.join(f't.{x} == @{x}' for x in query_params.keys())

        return [self.IndexDTO(**d) for d in
                self.adb.aql.execute(f'''
                FOR t IN tasks
                FILTER {filters}
                LET status = FIRST(
                  FOR s IN statuses FILTER s._key == t.status LIMIT 1
                  RETURN s
                )
                RETURN MERGE(t, {{status}})
                ''', bind_vars=query_params)]

    def insert(self, data):
        return self._collection.insert(data)

    @property
    def _collection(self):
        return self.adb.collection('tasks')
