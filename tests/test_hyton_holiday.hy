(import
  unittest
  datetime
  doctest
  trytond.tests.test_tryton
  decimal [Decimal]
  trytond.tests.test_tryton [ModuleTestCase with_transaction]
  trytond.modules.hyton.sugar [gets save]
  trytond.pool [Pool])

(defclass HytonHolidayTestCase [ModuleTestCase]
  "Test Hyton Holiday"
  (setv module "hyton_holiday")

  (defn [(with_transaction)] test_holiday [self]
    (let [[Holiday Calendar] (gets (Pool) ["holiday.holiday" "holiday.calendar"])
          date20200101 (datetime.date 2020 1 1)
          date20200102 (datetime.date 2020 1 2)
          calendar (save (Calendar :name "test-calendar"))
          holiday20200101 (save (Holiday :calendar calendar :date date20200101))]
      (.assertTrue self
                   (.is-holiday calendar date20200101))
      (.assertFalse self
                    (.is-holiday calendar date20200102)))
    
    ) 
  )

