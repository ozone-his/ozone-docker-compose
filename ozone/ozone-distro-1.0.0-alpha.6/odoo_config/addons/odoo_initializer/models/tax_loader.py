import logging

from .base_loader import BaseLoader

_logger = logging.getLogger(__name__)


class TaxLoader(BaseLoader):
    model_name = "account.tax"
    folder = "taxes"
