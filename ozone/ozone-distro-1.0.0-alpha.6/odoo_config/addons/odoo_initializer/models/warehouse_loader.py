import logging

from .base_loader import BaseLoader

_logger = logging.getLogger(__name__)


class WarehouseLoader(BaseLoader):
    model_name = "stock.warehouse"
    folder = "warehouse"
