from .base_loader import BaseLoader


class PartnerLoader(BaseLoader):
    model_name = "res.partner"
    folder = "partner"
    filters = {}