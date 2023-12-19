from .base_loader import BaseLoader


class ShopMappingLoader(BaseLoader):
    model_name = "order.type.shop.map"
    folder = "shop_mapping"
    filters = {}
