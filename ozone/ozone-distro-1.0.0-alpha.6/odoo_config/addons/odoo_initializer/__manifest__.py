# -*- coding: utf-8 -*-
{
    'name': "Odoo Initializer",

    'summary': """
        Odoo data Initializer""",

    'description': """
        Odoo add-on to import data provided as CSVs, loaded from a location on the server disk.
        This add-on helps implementers manage/deploy some of the Odoo data as files so to easily replicate environments.
        This add-on also specifically supports loading products and prices from an OpenMRS Initializer style CSV.
        See https://github.com/mekomsolutions/openmrs-module-initializer/
    """,

    'author': "Mekom Solutions",
    'website': "http://www.mekomsolutions.com",

    'category': 'Technical Settings',
    'version': '2.1.0',

    "depends": ["base", "base_import"],

    "application": True,
    "installable": True,
    "auto_install": True,
    "post_startup_hook": 'start_init'
}
