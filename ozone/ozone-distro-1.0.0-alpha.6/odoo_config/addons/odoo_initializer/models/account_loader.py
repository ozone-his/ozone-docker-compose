from .base_loader import BaseLoader


class AccountLoader(BaseLoader):
    model_name = "account.account"
    folder = "account"
    filters = {}
