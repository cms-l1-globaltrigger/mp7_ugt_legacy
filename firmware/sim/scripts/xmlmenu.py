#
# Copyright 2013-2017 Bernhard Arnold <bernahrd.arnold@cern.ch>
#                     Johannes Wittmann <johannes.wittmann@cern.ch>
#

"""This module provides a very basic XML menu reader making use of lmxl etree.

This class can be used for diagnostic output of algorithm params in TDF routines.

Load a menu from XML file:

>>> from xmlmenu import XmlMenu
>>> menu = XmlMenu("sample.xml")

Access menu meta inforamtion:

>>> menu.name
'L1Menu_Sample'
>>> menu.comment
'NO one expects the spanish inquisition!'

Iterate over algorithms:

>>> for algorithm in menu.algorithms:
...     print algorithm.index, algorithm.name

Filter algorithms by attributes:

>>> for module in range(menu.n_modules):
...     for algorithm in menu.algorithms.byModule(module):
...         do_something(...)

"""

import logging
import sys
import os

from lxml import etree

__all__ = ['XmlMenu',]

def filter_first(function, sequence):
    """Retruns first match of filter() result or None if nothing was found."""
    return (list(filter(function, sequence)) or [None])[0]

def get_xpath(elem, path, fmt=str, default=None):
    """Easy access using etree elem xpath method. Returns value of 'default' if
    element was not found (default is 'None').
    """
    results = elem.xpath('{path}/text()'.format(path=path))
    if results:
        return fmt(results[0])
    return default

def fast_iter(context, func, *args, **kwargs):
    """Fast XML iterator for huge XML files.
    http://lxml.de/parsing.html#modifying-the-tree
    Based on Liza Daly's fast_iter
    http://www.ibm.com/developerworks/xml/library/x-hiperfparse/
    See also http://effbot.org/zone/element-iterparse.htm
    """
    for event, elem in context:
        func(elem, *args, **kwargs)
        # It's safe to call clear() here because no descendants will be
        # accessed
        elem.clear()
        # Also eliminate now-empty references from the root node to elem
        for ancestor in elem.xpath('ancestor-or-self::*'):
            while ancestor.getprevious() is not None:
                del ancestor.getparent()[0]
    del context

class Algorithm(object):
    """Algorithm container class."""
    def __init__(self, index, name, expression, module_id=0, module_index=0, comment=None):
        self.index = index
        self.name = name
        self.expression = expression
        self.module_id = module_id
        self.module_index = module_index
        self.comment = comment or ""
    def __repr__(self):
        return "Algorithm(index={self.index}, " \
               "name=\"{self.name}\", " \
               "expression=\"{self.expression}\", " \
               "module(id={self.module_id}, index={self.module_index}))".format(**locals())

class AlgorithmContainer(list):
    """List container with extended lookup methods for content."""
    def byIndex(self, index):
        """Retruns algorithm by index or None if not found."""
        return filter_first(lambda algorithm: algorithm.index == index, self)
    def byModuleId(self, id):
        """Returns list of algorithms assigned to module id or empty list if none found."""
        return [algorithm for algorithm in self if algorithm.module_id == id]
    def byModuleIndex(self, index):
        """Returns list of algorithms assigned to module index or empty list if none found."""
        return [algorithm for algorithm in self if algorithm.module_index == index]
    def byName(self, name):
        """Retruns algorithm by name or None if not found."""
        return filter_first(lambda algorithm: algorithm.name == name, self)

class XmlMenu(object):
    """Container holding some information of the XML menu.
    Menu attributes:
    *filename* holds the filename the menu was read from
    *name* is the menu's name
    *uuid_menu* is the menu's UUID
    *uuid_firmware* is the menu's firmware UUID (set by the VHDL producer)
    *algorithms* holds an instance of type AlgorithmContainer permitting a
    convenient access to the loaded algorithms.

    Example:
    >>> menu = XmlMenu("sample.xml")
    >>> menu.name
    'L1Menu_Sample'
    >>> menu.algorithms.byModule(2)
    [...]
    """

    def __init__(self, filename=None):
        self.filename = None
        self.name = None
        self.uuid_menu = None
        self.uuid_firmware = None
        self.grammar_version = ""
        self.is_valid = False
        self.is_obsolete = False
        self.n_modules = 0
        self.comment = ""
        self.algorithms = AlgorithmContainer()
        if filename:
            self.read(filename)

    def read(self, filename):
        """Read XML from file and parse its content."""
        self.filename = os.path.abspath(filename)
        self.algorithms = AlgorithmContainer()
        with open(self.filename) as fp:
            # Access static elements
            context = etree.parse(fp)
            self.name = get_xpath(context, 'name')
            self.uuid_menu = get_xpath(context, 'uuid_menu')
            self.uuid_firmware = get_xpath(context, 'uuid_firmware')
            self.grammar_version = get_xpath(context, 'grammar_version')
            self.is_valid = get_xpath(context, 'is_valid', bool)
            self.is_obsolete = get_xpath(context, 'is_obsolete', bool)
            self.n_modules = get_xpath(context, 'n_modules', int)
            self.comment = get_xpath(context, 'comment', default="")
            # Access list of algorithms
            fp.seek(0) # Seek begin of file
            context = etree.iterparse(fp, tag='algorithm')
            fast_iter(context, self._read_algorithm)

    def _read_algorithm(self, elem):
        """Fetch information from an algorithm tag and appends it to the list of algorithms."""
        name = get_xpath(elem, 'name')
        index = get_xpath(elem, 'index', int)
        expression = get_xpath(elem, 'expression')
        module_id = get_xpath(elem, 'module_id', int)
        module_index = get_xpath(elem, 'module_index', int)
        comment = get_xpath(elem, 'comment', default="")
        algorithm = Algorithm(index, name, expression, module_id, module_index, comment)
        self.algorithms.append(algorithm)

if __name__ == '__main__':
    """Basic unittest..."""

    logging.getLogger().setLevel(logging.DEBUG)

    filename = sys.argv[1]
    menu = XmlMenu(filename)

    logging.info("menu.filename      : %s", menu.filename)
    logging.info("menu.name          : %s", menu.name)
    logging.info("menu.uuid_menu     : %s", menu.uuid_menu)
    logging.info("menu.uuid_firmware : %s", menu.uuid_firmware)
    logging.info("menu.n_modules     : %s", menu.n_modules)
    logging.info("menu.is_valid      : %s", menu.is_valid)
    logging.info("menu.is_obsolete   : %s", menu.is_obsolete)
    logging.info("menu.comment       : %s", menu.comment)

    for algorithm in menu.algorithms:
        logging.info("algorithm.name         : %s", algorithm.name)
        logging.info("algorithm.index        : %s", algorithm.index)
        logging.info("algorithm.module_id    : %s", algorithm.module_id)
        logging.info("algorithm.module_index : %s", algorithm.module_index)
        if algorithm.comment:
            logging.info("algorithm.comment : %s", algorithm.comment)
