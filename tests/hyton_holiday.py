import datetime

from trytond.modules.hyton.sugar import gets, save
from trytond.modules.hyton_holiday.holiday import calendars_next_workday
from trytond.pool import Pool
from trytond.tests.test_tryton import ModuleTestCase, with_transaction


class HytonHolidayTestCase(ModuleTestCase):
    "Test Hyton Holiday"

    module = "hyton_holiday"

    @with_transaction()
    def test_holiday(self):
        [holiday_model, calendar_model] = gets(Pool(), ["holiday.holiday", "holiday.calendar"])

        date20240101 = datetime.date(2024, 1, 1)
        date20240102 = datetime.date(2024, 1, 2)

        calendar = save(calendar_model(name="test-calendar"))
        calendar_empty = save(calendar_model(name="test-calendar-empty"))
        calendar_2 = save(calendar_model(name="test-calendar2"))

        save(holiday_model(calendar=calendar, date=date20240101))
        save(holiday_model(calendar=calendar_2, date=date20240102))

        self.assertTrue(calendar.is_holiday(date20240101))
        self.assertFalse(calendar.is_holiday(date20240102))

        self.assertEqual(
            calendars_next_workday([calendar], datetime.date(2023, 12, 29)),
            datetime.date(2024, 1, 2),
        )
        self.assertEqual(
            calendars_next_workday([calendar_empty], datetime.date(2023, 12, 29)),
            datetime.date(2024, 1, 1),
        )
        self.assertEqual(
            calendars_next_workday([], datetime.date(2023, 12, 29)),
            datetime.date(2024, 1, 1),
        )
        self.assertEqual(
            calendars_next_workday([calendar_empty, calendar], datetime.date(2023, 12, 29)),
            datetime.date(2024, 1, 2),
        )
        self.assertEqual(
            calendars_next_workday(
                [calendar_empty, calendar, calendar_2],
                datetime.date(2023, 12, 29),
            ),
            datetime.date(2024, 1, 3),
        )
