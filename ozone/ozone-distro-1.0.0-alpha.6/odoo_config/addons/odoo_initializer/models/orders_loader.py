from .base_loader import BaseLoader


class OrdersLoader(BaseLoader):
    model_name = "product.template"
    field_mapping = {
        "lst_price": "odoo_price",
        "product_variant_ids/categ_id/id": "odoo_category",
        "type": "odoo_type",
        "name": "Short name:en",
        "product_variant_ids/uuid": "Uuid",
        "id": "odoo_id",
        "description": "Data class",
    }
    folder = "concepts"
    filters = {
        "Data class": ["LabTest",
                       "Radiology"]
    }
