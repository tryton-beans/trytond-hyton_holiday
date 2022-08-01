try:
    from trytond.modules.hyton_holiday.tests.test_hyton_holiday import suite
except ImportError:
    from .test_hyton_holiday import suite

__all__ = ['suite']


