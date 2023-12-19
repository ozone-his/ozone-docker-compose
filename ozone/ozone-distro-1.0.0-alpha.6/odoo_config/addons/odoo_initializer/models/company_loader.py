from .base_loader import BaseLoader


class CompanyLoader(BaseLoader):
    model_name = "res.company"
    folder = "company"
    filters = {}
