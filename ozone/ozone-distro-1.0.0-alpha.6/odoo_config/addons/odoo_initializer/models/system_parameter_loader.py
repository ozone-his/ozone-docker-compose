from .base_loader import BaseLoader


class SystemParameterLoader(BaseLoader):
    model_name = "ir.config_parameter"
    folder = "system_parameter"
    filters = {}