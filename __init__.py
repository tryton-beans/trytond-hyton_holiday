import hy
from trytond.pool import Pool
from . import holiday

def register():
    Pool.register(
        holiday.Calendar,
        holiday.Holiday,
        holiday.CalendarCompany,
        module='hyton_holiday', type_='model')
