from .base_loader import BaseLoader


class JournalLoader(BaseLoader):
    model_name = "account.journal"
    folder = "journal"
    filters = {}
