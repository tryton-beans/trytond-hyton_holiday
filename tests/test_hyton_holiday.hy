(import
  unittest
  datetime
  doctest
  trytond.tests.test_tryton
  decimal [Decimal]
  trytond.tests.test_tryton [ModuleTestCase with_transaction]
  trytond.modules.hyton.sugar [gets save]
  trytond.modules.hyton_holiday.holiday [calendar-next-workday]
  trytond.pool [Pool])

(defclass HytonHolidayTestCase [ModuleTestCase]
  "Test Hyton Holiday"
  (setv module "hyton_holiday")

  (defn [(with_transaction)] test_holiday [self]
    (let [[Holiday Calendar] (gets (Pool) ["holiday.holiday" "holiday.calendar"])
          date20240101 (datetime.date 2024 1 1)
          date20240102 (datetime.date 2024 1 2)
          calendar (save (Calendar :name "test-calendar"))
          calendar-empty (save (Calendar :name "test-calendar-empty"))
          calendar-2 (save (Calendar :name "test-calendar2"))
          holiday20200101 (save (Holiday :calendar calendar :date date20240101))
          holiday20200102 (save (Holiday :calendar calendar-2 :date date20240102))]
      (.assertTrue self
                   (.is-holiday calendar date20240101))
      (.assertFalse self
                    (.is-holiday calendar date20240102))

      ;; 2024-01-01 is a holiday and its a monday
      ;; next working day is 2024-01-02 for 2023/12/29 (friday)
      (.assertEqual self
                    (calendar-next-workday [calendar] (datetime.date 2023 12 29))
                    (datetime.date 2024 1 2))
      (.assertEqual self
                    (calendar-next-workday [calendar-empty] (datetime.date 2023 12 29))
                    (datetime.date 2024 1 1))
      (.assertEqual self
                    (calendar-next-workday [] (datetime.date 2023 12 29))
                    (datetime.date 2024 1 1))
      (.assertEqual self
                    (calendar-next-workday [calendar-empty calendar] (datetime.date 2023 12 29))
                    (datetime.date 2024 1 2))
      (.assertEqual self
                    (calendar-next-workday [calendar-empty
                                   calendar
                                   calendar-2] (datetime.date 2023 12 29))
                    (datetime.date 2024 1 3)))))

