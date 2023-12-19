from .base_loader import BaseLoader


class ProductCategoryLoader(BaseLoader):
    model_name = "product.category"
    folder = "product_category"
    filters = {}