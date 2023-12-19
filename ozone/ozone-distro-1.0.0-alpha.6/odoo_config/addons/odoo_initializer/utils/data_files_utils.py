import logging
import os, re
import hashlib
import csv
import tempfile
import xml.etree.ElementTree as ET
from os.path import dirname, basename, split
from .config import config

_logger = logging.getLogger(__name__)


class DataFilesUtils:

    @staticmethod
    def get_data_folder_path(data_files_source):
        data_files_source = data_files_source.lower()
        assert data_files_source in ["odoo", "openmrs"]
        return (
            config.openmrs_path if data_files_source == "openmrs" else config.odoo_path
        )

    @staticmethod
    def get_csv_content(file_data):
        extracted_csv = csv.DictReader(file_data)
        csv_dict = []
        for row in extracted_csv:
            csv_dict.append(row)
        return csv_dict

    @staticmethod
    def get_xml_content(file_data):
        file_content = file_data.read()
        tree = ET.ElementTree()
        if file_content:
            tree = ET.fromstring(file_content)
        return tree

    def get_files(self, folder, allowed_extensions, model_name):
        import_files = []
        for data_files_source in config.data_files_paths:
            path = os.path.join(data_files_source, folder)
            for root, dirs, files in os.walk(path):
                for file_ in files:
                    file_path = os.path.join(path, file_)
                    filename, ext = os.path.splitext(file_)
                    if str(ext).lower() in allowed_extensions:
                        if self.file_already_processed(file_path, model_name):
                            _logger.info(
                                "Skipping already processed file: " + str(file_)
                            )
                            continue
                        import_files.append(file_path)

        return import_files

    def get_file_content(self, file_path, allowed_extensions):
        with open(file_path, "r") as file_data:
            if ".csv" in allowed_extensions:
                return self.get_csv_content(file_data)
            elif ".xml" in allowed_extensions:
                return self.get_xml_content(file_data)

    @staticmethod
    def get_checksum_path(file_, model_name):
        file_name = basename(file_)
        file_dir = split(dirname(file_))[1]
        checksum_dir = config.checksum_folder or (
            split(dirname(file_))[0] + "_checksum"
        )
        checksum_path = os.path.join(checksum_dir, file_dir, (model_name + "_" + file_name)) + ".checksum"
        return checksum_path

    def file_already_processed(self, file_, model_name):
        checksum_path = self.get_checksum_path(file_, model_name)
        md5 = self.md5(file_)
        if os.path.exists(checksum_path):
            with open(checksum_path, "r") as f:
                old_md5 = f.read()
                f.close()
                return old_md5 == md5
        if not os.path.isdir(dirname(checksum_path)):
            try:
                os.makedirs(dirname(checksum_path))
            except OSError:
                raise
        return False

    @staticmethod
    def create_checksum_file(checksum_path, md5):
        with open(checksum_path, "w") as fw:
            fw.write(md5)

    @staticmethod
    def md5(fname):
        hash_md5 = hashlib.md5()
        with open(fname, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_md5.update(chunk)
        return hash_md5.hexdigest()

    @staticmethod
    def build_csv(data):
        tmp_file = tempfile.TemporaryFile(mode="w+")
        output = csv.DictWriter(tmp_file, fieldnames=data[0].keys())
        output.writeheader()
        output.writerows(data)
        tmp_file.seek(0)
        csv_string = tmp_file.read()
        tmp_file.close()
        csv_string.replace("\r\n", "\n")
        return csv_string

    @staticmethod
    def extract_reference(text_value):
        extract = re.search("\$\{(.+?)\}", text_value)
        if extract:
            return extract.group(1) or ""

    @staticmethod
    def replace_reference(text_, ref_value):
        return re.sub("\$\{(.*?)\}", ref_value, text_)

data_files = DataFilesUtils()
