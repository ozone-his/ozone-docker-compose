from .base_loader import BaseLoader


class DefaultValueLoader(BaseLoader):
    model_name = "ir.values"
    folder = "default_value"
    filters = {}