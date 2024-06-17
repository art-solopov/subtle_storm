from typing import Any, Dict, List
from enum import Enum

from pydantic import BaseModel, Field

import arango


class ArangoDTO(BaseModel):
    key: str = Field(alias='_key')
    id: str = Field(alias='_id')
    rev: str = Field(alias='_rev')


class Base:
    def __init__(self, adb: arango.database.Database):
        self.adb = adb

    collection_name: str = ''

    @property
    def _collection(self):
        return self.adb.collection(self.collection_name)


class ProjectsRepository(Base):
    class IndexDTO(ArangoDTO):
        name: str

    class StatusCategory(Enum):
        NEW = 'new'
        IN_PROGRESS = 'in_progress'
        DONE = 'done'

    class StatusDTO(BaseModel):
        name: str
        category: 'ProjectsRepository.StatusCategory'

    class DTO(ArangoDTO):
        name: str
        statuses: List['ProjectsRepository.StatusDTO']

    collection_name = 'projects'

    def index(self):
        aql = '''
        FOR p IN projects
        RETURN KEEP(p, '_id', '_key', '_rev', 'name')
        '''
        return [self.IndexDTO(**d) for d in self.adb.aql.execute(aql)]

    def show(self, key):
        doc = self._collection.get(key)
        return self.DTO(**doc) if doc else None

    def increase_task_counter(self, key):
        aql = '''
        LET p = FIRST(FOR p IN projects FILTER p._key == @key RETURN p)
        UPDATE p WITH {_taskCount: p._taskCount + 1} IN projects
        RETURN NEW._taskCount
        '''
        data = self.adb.aql.execute(aql, bind_vars={'key': key})
        return next(data)


class StatusRepository(Base):
    class DTO(ArangoDTO):
        project: str
        name: str
        position: int

    collection_name = 'statuses'


class TasksRepository(Base):
    class SortFields(str, Enum):
        title = 'title'

    class DTO(ArangoDTO):
        project: str
        number: int
        title: str
        description: str | None = None

    class IndexDTO(DTO):
        status: str

    collection_name = 'tasks'

    def index(self, query_params: Dict[str, Any]):
        filters = ' AND '.join(f't.{x} == @{x}' for x in query_params.keys())

        return [self.IndexDTO(**d) for d in
                self.adb.aql.execute(f'''
                FOR t IN tasks
                FILTER {filters}
                RETURN t
                ''', bind_vars=query_params)]

    def insert(self, data):
        return self._collection.insert(data)
