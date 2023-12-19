from .base_loader import BaseLoader


class DrugLoader(BaseLoader):
    model_name = "product.product"
    field_mapping = {
        "lst_price": "odoo_price",
        "categ_id/id": "odoo_category",
        "type": "odoo_type",
        "name": "Name",
        "uuid": "Uuid",
        "id": "odoo_id",
        "uom_id/id": "odoo_uom",
        "standard_price": "odoo_cost",
        "uom_po_id/id": "odoo_purchase_uom"
    }
    folder = "drugs"
    field_rules = {
        "lst_price": "NO_UPDATE",
        "standard_price": "NO_UPDATE"
    }
