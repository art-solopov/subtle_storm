import logging

from arango import ArangoClient


logger = logging.getLogger(__name__)


class ArangoConnection:
    # TODO: maybe add config from app
    def __init__(self):
        logger.info('Creating database')
        self.client = ArangoClient(hosts='http://localhost:8529')
        self.db = self.client.db('pya')
