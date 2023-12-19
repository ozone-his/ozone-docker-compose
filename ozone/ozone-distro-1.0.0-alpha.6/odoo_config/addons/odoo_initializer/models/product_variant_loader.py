from .base_loader import BaseLoader


class ProductVariantLoader(BaseLoader):
    model_name = "product.product"
    folder = "product_variant"
    filters = {}
    field_rules = {
        "lst_price": "NO_UPDATE"
    }
