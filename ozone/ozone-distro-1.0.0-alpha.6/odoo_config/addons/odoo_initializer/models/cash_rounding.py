import logging

from .base_loader import BaseLoader

_logger = logging.getLogger(__name__)


class CashRoundingLoader(BaseLoader):
    model_name = "account.cash.rounding"
    folder = "rounding"

