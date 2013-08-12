import os
import os.path
import sys
from unittest import TestCase

import hy # NOQA
from nose.plugins import Plugin


class HyNose(Plugin):
    name = 'hynose'

    def options(self, parser, env=os.environ):
        super(HyNose, self).options(parser, env=env)

    def configure(self, options, conf):
        super(HyNose, self).configure(options, conf)

    def wantFile(self, filename):
        base = os.path.basename(filename)
        return base.startswith('test_') and base.endswith('.hy')

    def loadTestsFromFile(self, filename):
        name = os.path.basename(filename)
        modname = os.path.splitext(name)[0]

        dirname = os.path.dirname(filename)
        sys.path.append(dirname)
        mod = __import__(modname)

        for member in mod.__dict__.values():
            if isinstance(member, type) and issubclass(member, TestCase):
                for method in member.__dict__.iterkeys():
                    if method.startswith('test_'):
                        yield member(methodName=method)
