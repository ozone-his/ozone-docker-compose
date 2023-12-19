from .base_loader import BaseLoader


class StockLocationLoader(BaseLoader):
    model_name = "stock.location"
    folder = "stock_location"
    filters = {}
