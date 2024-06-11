from pydantic import BaseModel, Field


class Task(BaseModel):
    title: str = Field(max_length=512)
    description: str | None = None
    status: str
    project: str
