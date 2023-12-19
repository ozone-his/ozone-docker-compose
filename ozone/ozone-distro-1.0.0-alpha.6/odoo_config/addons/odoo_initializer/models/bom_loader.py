import logging

from .base_loader import BaseLoader

_logger = logging.getLogger(__name__)


class BomLoader(BaseLoader):
    model_name = "mrp.bom"
    folder = "bill_of_material"
