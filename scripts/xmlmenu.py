#!/usr/bin/env python
#
# Copyright 2013-2019 Bernhard Arnold <bernhard.arnold@cern.ch>
#           2013-2017 Johannes Wittmann <johannes.wittmann@cern.ch>
#

"""This module provides a very basic XML menu reader making use of lmxl etree.

This class can be used for diagnostic output of algorithm params in TDF routines.

Load a menu from XML file:

>>> from xmlmenu import XmlMenu
>>> menu = XmlMenu("sample.xml")

Access menu meta information:

>>> menu.name
'L1Menu_Sample'
>>> menu.comment
'NO-body expects the spanish inquisition!'

Iterate over algorithms:

>>> for algorithm in menu.algorithms:
...     print algorithm.index, algorithm.name

Filter algorithms by attributes:

>>> for module in range(menu.n_modules):
...     for algorithm in menu.algorithms.byModule(module):
...         do_something(...)

"""

import sys, os

try:
    from lxml import etree
except ImportError:
    raise RuntimeError("package `lxml` is missing, please install `python-lxml` using your favorite package manager.")

__all__ = ['XmlMenu', '__doc__', '__version__']
__version__ = '1.0.0'

def filter_first(function, sequence):
    """Retruns first match of filter() result or None if nothing was found."""
    return list(list(filter(function, sequence)) or [None])[0]

def get_xpath(elem, path, fmt=str):
    """Easy access using etree elem xpath method."""
    try:
        return fmt(elem.xpath('{path}/text()'.format(path=path))[0])
    except IndexError:
        return fmt() # retrun empty

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
    """Container holding a subset of algorithm information.
    Algorithm attributes:
    *index* is the algorithm index
    *name* is the algorithm name
    *expression* is the algorithm expression
    *module_id* is the implementation specific algorithm module ID
    *module_index* is the implementation specific algorithm module index
    *comment* is an optional comment
    """
    def __init__(self, index, name, expression, module_id=0, module_index=0, comment=None):
        self.index = index
        self.name = name
        self.expression = expression
        self.module_id = module_id
        self.module_index = module_index
        self.comment = comment or ""

    def asdict(self):
        """Retrun content as dictionary."""
        return self.__dict__

    def __repr__(self):
        return "Algorithm(index={self.index}, " \
               "name=\"{self.name}\", " \
               "expression=\"{self.expression}\", " \
               "module(id={self.module_id}, index={self.module_index}))".format(**locals())

class AlgorithmContainer(list):
    """Algorithm list container with extended lookup methods for content."""
    def byIndex(self, index):
        """Retruns algorithm by index or None if not found."""
        return filter_first(lambda algorithm: algorithm.index == index, self)

    def byModuleId(self, id):
        """Returns list of algorithms assigned to module id or empty list if none found."""
        return filter(lambda algorithm: algorithm.module_id == id, self)

    def byModuleIndex(self, index):
        """Returns list of algorithms assigned to module index or empty list if none found."""
        return filter(lambda algorithm: algorithm.module_index == index, self)

    def byName(self, name):
        """Retruns algorithm by name or None if not found."""
        return filter_first(lambda algorithm: algorithm.name == name, self)

    def asdict(self):
        """Retrun content as dictionary."""
        return [algorithm.asdict() for algorithm in self]

class XmlMenu(object):
    """Container holding a subset of information of the XML menu.
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
        if filename: self.read(filename)

    def asdict(self):
        """Retrun content as dictionary."""
        d = dict(self.__dict__) # copy
        d['algorithms'] = self.algorithms.asdict()
        return d

    def read(self, filename):
        """Read XML from file and parse its content."""
        self.filename = os.path.abspath(filename)
        self.algorithms = AlgorithmContainer()
        with open(self.filename, 'rb') as fp:
            # Access static elements
            context = etree.parse(fp)
            self.name = get_xpath(context, 'name')
            self.uuid_menu = get_xpath(context, 'uuid_menu')
            self.uuid_firmware = get_xpath(context, 'uuid_firmware')
            self.grammar_version = get_xpath(context, 'grammar_version')
            self.is_valid = get_xpath(context, 'is_valid', bool)
            self.is_obsolete = get_xpath(context, 'is_obsolete', bool)
            self.n_modules = get_xpath(context, 'n_modules', int)
            self.comment = get_xpath(context, 'comment')
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
        comment = get_xpath(elem, 'comment')
        algorithm = Algorithm(index, name, expression, module_id, module_index, comment)
        self.algorithms.append(algorithm)

def main():
    import json
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help="XML menu to load")
    args = parser.parse_args()

    menu = XmlMenu(args.filename)

    dump = json.dumps(menu.asdict(), indent=2)
    sys.stdout.write(dump)
    sys.stdout.flush()

if __name__ == '__main__':
    main()
