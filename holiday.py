from trytond.model import Index, ModelSQL, ModelView, Unique, fields
from trytond.pool import Pool

from trytond.modules.hyton.date import plus_days_weekday
from trytond.modules.hyton.utils import some


class Holiday(ModelSQL, ModelView):
    "A Holiday Day in a Holiday Calendar"

    __name__ = "holiday.holiday"
    name = fields.Char("Name")
    date = fields.Date("Date", required=True)
    same_day_each_year = fields.Boolean("Same day each year")
    calendar = fields.Many2One("holiday.calendar", "Holiday Calendar", required=True)

    @classmethod
    def __setup__(cls):
        super().__setup__()
        t = cls.__table__()
        cls._sql_indexes.add(Index(t, (t.date, Index.Range())))


class Calendar(ModelSQL, ModelView):
    "Holidays Calendar, group of holiday Days"

    __name__ = "holiday.calendar"
    name = fields.Char("Name", required=True)
    holidays = fields.One2Many("holiday.holiday", "calendar", "holiday")

    @classmethod
    def __setup__(cls):
        super(Calendar, cls).__setup__()
        t = cls.__table__()
        cls._sql_constraints.append(("name_uniq", Unique(t, t.name), "Name must be unique"))

    def is_holiday(self, date):
        holiday_model = Pool().get("holiday.holiday")
        holiday = holiday_model.search(
            [("calendar", "=", self.id), ("date", "=", date)],
            limit=1,
        )
        return bool(holiday)


def calendars_next_workday(calendars, date, days=1):
    next_date = plus_days_weekday(date, days)
    if calendars and some(lambda cal: cal.is_holiday(next_date), calendars):
        return calendars_next_workday(calendars, next_date, days)
    return next_date


def calendars_to_workday(calendars, date):
    if calendars and some(lambda cal: cal.is_holiday(date), calendars):
        return calendars_next_workday(calendars, date, 1)
    return date
