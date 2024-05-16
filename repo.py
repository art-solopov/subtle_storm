from typing import Any, Dict
from dataclasses import dataclass
from enum import Enum

from pydantic import BaseModel, Field, computed_field, model_validator

import arango


class ArangoDTO(BaseModel):
    @dataclass
    class ArangoData:
        key: str
        id: str
        rev: str

    arango_data: ArangoData

    @model_validator(mode='before')
    @classmethod
    def set_arango_data(cls, data: Any):
        if isinstance(data, dict):
            assert '_key' in data
            assert '_id' in data
            assert '_rev' in data
            data['arango_data'] = cls.ArangoData(key=data['_key'], id=data['_id'], rev=data['_rev'])
        return data


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
                LET status = (
                  FOR s IN statuses FILTER s._id == t.status LIMIT 1
                  RETURN s
                )
                RETURN MERGE(t, {{status: FIRST(status)}})
                ''', bind_vars=query_params)]

    @property
    def _collection(self):
        return self.adb.collection('tasks')
