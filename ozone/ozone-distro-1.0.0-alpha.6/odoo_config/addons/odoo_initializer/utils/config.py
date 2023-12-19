import logging
import odoo.tools.config

_logger = logging.getLogger(__name__)


class Config:
    def __init__(self):
        self.init = False
        try:
            data_files_paths_property = odoo.tools.config[
                "initializer_data_files_paths"
            ]
            self.data_files_paths = data_files_paths_property.split(",")
        except KeyError:
            _logger.warning("'initializer_data_files_paths' property is not set")
            self.data_files_paths = []
        try:
            self.db_name = odoo.tools.config["db_name"]
        except KeyError:
            pass
        try:
            self.checksum_folder = odoo.tools.config["initializer_checksums_path"]
        except KeyError:
            self.checksum_folder = None
        try:
            self.config_file_path = odoo.tools.config["initializer_config_file_path"]
        except KeyError:
            self.config_file_path = None


config = Config()
