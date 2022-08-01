import hy
from trytond.pool import Pool
from . import holiday

def register():
    Pool.register(
        holiday.Calendar,
        holiday.Holiday,
        module='hyton_holiday', type_='model')
