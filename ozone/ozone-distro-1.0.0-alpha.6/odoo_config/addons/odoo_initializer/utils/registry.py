import logging

from odoo import api
import odoo
from .config import config


_logger = logging.getLogger(__name__)


class Registry(object):

    init = False
    reg = None
    cursor = None
    env = None

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(Registry, cls).__new__(cls)
        return cls.instance

    def initialize(self, cr):
        if self.reg is None:
            uid = odoo.SUPERUSER_ID
            self.env = odoo.api.Environment(cr, uid, {})
            self.reg = self.env.registry
            self.cursor = cr

    def clear(self):
        if not self.cursor.closed:
            self.cursor.commit()


registry = Registry()
