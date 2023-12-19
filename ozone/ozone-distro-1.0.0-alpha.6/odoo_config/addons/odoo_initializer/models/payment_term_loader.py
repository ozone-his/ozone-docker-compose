from .base_loader import BaseLoader


class PaymentTermLoader(BaseLoader):
    model_name = "account.payment.term"
    folder = "payment_term"
    filters = {}
