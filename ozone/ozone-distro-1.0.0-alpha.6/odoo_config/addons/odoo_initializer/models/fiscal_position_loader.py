from .base_loader import BaseLoader


class FiscalPositionLoader(BaseLoader):
    model_name = "account.fiscal.position"
    folder = "fiscal_position"
    filters = {}
