import logging
import json
import os

from ..models.base_loader import BaseLoader
from .config import config

_logger = logging.getLogger(__name__)


class ModelsImport:

    @staticmethod
    def get_property_value(model, property, required=False):
        value = ""
        try:
            value = model[property]
        except KeyError:
            if required:
                raise KeyError("The field " + property + "is required")
        return value

    def get_iniz_config_file_models(self):
        if not config.config_file_path:
            return ""
        if not os.path.exists(config.config_file_path):
            _logger.warning("Configuration file is specified but does not exists")
            return ""
        with open(config.config_file_path) as json_file:
            data = ""
            try:
                data = json.load(json_file)
            except ValueError:
                _logger.warning("Configuration file is not a json file, skipping")
                return ""

            config_loaders = []

            try:
                for model in data['models']:
                    loader = BaseLoader()
                    loader.folder = self.get_property_value(model, "folder", True)
                    loader.model_name = self.get_property_value(model, "model_name", True)
                    loader.field_mapping = self.get_property_value(model, "field_mapping")
                    loader.filters = self.get_property_value(model, "filters")
                    loader.field_rules = self.get_property_value(model, "field_rules")
                    config_loaders.append(loader)
                return config_loaders
            
            except KeyError:
                _logger.warning("Configuration file does not have models section")
