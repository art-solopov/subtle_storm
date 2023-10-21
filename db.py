from arango import ArangoClient


class ArangoConnection:
    # TODO: maybe add config from app
    def __init__(self):
        self.client = ArangoClient(hosts='http://localhost:8529')
        self.db = self.client.db('pya')
