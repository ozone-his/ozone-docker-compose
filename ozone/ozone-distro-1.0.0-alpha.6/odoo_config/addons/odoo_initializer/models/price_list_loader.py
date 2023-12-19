import logging

from .base_loader import BaseLoader

_logger = logging.getLogger(__name__)


class PriceListLoader(BaseLoader):
    model_name = "product.pricelist"
    folder = "pricelist"

