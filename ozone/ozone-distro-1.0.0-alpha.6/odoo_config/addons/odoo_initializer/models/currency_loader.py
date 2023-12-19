from .base_loader import BaseLoader


class CurrencyLoader(BaseLoader):
    model_name = "res.currency"
    folder = "currency"
    filters = {}