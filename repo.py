from typing import Any
from dataclasses import dataclass

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
        return self._collection.get(key)

    @property
    def _collection(self):
        return self.adb.collection('projects')
