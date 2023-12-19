from .base_loader import BaseLoader


class CountryLoader(BaseLoader):
    model_name = "res.country"
    folder = "country"
    filters = {}
