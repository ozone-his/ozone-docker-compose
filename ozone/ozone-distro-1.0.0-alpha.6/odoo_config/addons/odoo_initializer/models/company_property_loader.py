from .base_loader import BaseLoader


class CompanyPropertyLoader(BaseLoader):
    update_existing_record = True
    model_name = "ir.property"
    folder = "company_property"
    filters = {}
