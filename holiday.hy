(import
  trytond.model [Index ModelSQL ModelView fields Unique]
  trytond.pool [Pool])


(defclass Holiday [ModelSQL ModelView]
  "A Holiday Day in a Holiday Calendar"
  (setv __name__ "holiday.holiday"
        name (.Char fields "Name")
        date (.Date fields "Date"
                    :required True)
        calendar (.Many2One fields "holiday.calendar" "Holiday Calendar"
                            :required True))


  (defn [classmethod] __setup__ [cls]
    (.__setup__ (super))
    (setv t (.__table__ cls))
    (.add cls._sql-indexes
          (Index t #(t.date (.Range Index)))
          ))
  )


(defclass Calendar[ModelSQL ModelView]
  "Holidays Calendar, group of holiday Days"
  (setv __name__ "holiday.calendar"
        name (.Char fields "Name" :required True)
        holidays (.One2Many fields "holiday.holiday" "calendar" "holiday"))
 
  (defn [classmethod] __setup__ [cls]
    (.__setup__ (super Calendar cls))
    (setv t (.__table__ cls))
    (.append cls._sql-constraints
             #("name_uniq" (Unique t t.name)
                           "Name must be unique")))

  (defn holiday? [self date]
    (let [Holiday (.get (Pool) "holiday.holiday")
          holiday (.search Holiday [#("calendar" "=" self.id)
                             #("date" "=" date)]
                          :limit 1)]
      (bool holiday)
      )))
