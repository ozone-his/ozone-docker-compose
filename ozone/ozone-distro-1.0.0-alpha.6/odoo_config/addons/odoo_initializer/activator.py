import logging

from .utils import config
from .utils.registry import registry
from .utils.models_import import ModelsImport

from .models.country_loader import CountryLoader
from .models.partner_loader import PartnerLoader
from .models.company_loader import CompanyLoader
from .models.company_property_loader import CompanyPropertyLoader
from .models.stock_location_loader import StockLocationLoader
from .models.payment_term_loader import PaymentTermLoader
from .models.price_list_loader import PriceListLoader
from .models.account_loader import AccountLoader
from .models.journal_loader import JournalLoader
from .models.fiscal_position_loader import FiscalPositionLoader
from .models.product_category_loader import ProductCategoryLoader
from .models.drug_loader import DrugLoader
from .models.product_loader import ProductLoader
from .models.product_variant_loader import ProductVariantLoader
from .models.system_parameter_loader import SystemParameterLoader
from .models.default_value_loader import DefaultValueLoader
from .models.currency_loader import CurrencyLoader
from .models.orders_loader import OrdersLoader
from .models.language_loader import LanguageLoader
from .models.decimal_precision_loader import DecimalPrecisionLoader
from .models.uom_loader import UOMLoader
from .models.setting_loader import SettingLoader
from .models.tax_loader import TaxLoader
from .models.warehouse_loader import WarehouseLoader
from .models.bom_loader import BomLoader
from .models.cash_rounding import CashRoundingLoader

_logger = logging.getLogger(__name__)


def start_init(cr):
    _logger.info("start initialization process")

    # loaders are ordered based on dependency to each others

    registered_loaders = [
        SettingLoader,
        CurrencyLoader,
        CountryLoader,
        FiscalPositionLoader,
        PartnerLoader,
        CompanyLoader,
        AccountLoader,
        JournalLoader,
        PaymentTermLoader,
        UOMLoader,
        StockLocationLoader,
        ProductCategoryLoader,
        DrugLoader,
        OrdersLoader,
        ProductVariantLoader,
        ProductLoader,
        PriceListLoader,
        DefaultValueLoader,
        CompanyPropertyLoader,
        SystemParameterLoader,
        DecimalPrecisionLoader,
        TaxLoader,
        WarehouseLoader,
        BomLoader,
        CashRoundingLoader,
        LanguageLoader,
    ]

    registry.initialize(cr)
    for registered_loader in registered_loaders:
        loader = registered_loader()
        loader.load_()

        config.init = False

    _logger.info("load Initializer configurable loaders file")

    configurable_loaders = ModelsImport().get_iniz_config_file_models()

    for config_loader in configurable_loaders:
        loader = config_loader
        loader.load_()

    registry.clear()
    _logger.info("initialization done")
