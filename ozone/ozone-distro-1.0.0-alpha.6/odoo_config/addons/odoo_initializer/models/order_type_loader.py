from .base_loader import BaseLoader


class OrderTypeLoader(BaseLoader):
    model_name = "order.type"
    folder = "order_type"
    filters = {}
