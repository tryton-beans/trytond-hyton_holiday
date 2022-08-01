(import
  [trytond.model [ModelSQL ModelView fields Unique]]
  [trytond.pool [Pool]])
(require [hy.contrib.walk [let]])

(defclass Holiday [ModelSQL ModelView]
  "A Holiday Day in a Holiday Calendar"
  (setv --name-- "holiday.holiday"
        name (.Char fields "Name")
        date (.Date fields "Date"
                    :select True
                    :required True)
        calendar (.Many2One fields "holiday.calendar" "Holiday Calendar"
                            :select True
                            :required True)))


(defclass Calendar[ModelSQL ModelView]
  "Holidays Calendar, group of holiday Days"
  (setv --name-- "holiday.calendar"
        name (.Char fields "Name" :required True)
        holidays (.One2Many fields "holiday.holiday" "calendar" "holiday"))
  
  #@(classmethod
      (defn --setup-- [cls]
        (.--setup-- (super Calendar cls))
        (setv t (.--table-- cls))
        (.append cls.-sql-constraints
                 (, "name_uniq" (Unique t t.name)
                    "Name must be unique"))
        ))

  (defn holiday? [self date]
    (let [Holiday (.get (Pool) "holiday.holiday")
          holiday (.search Holiday [(, "calendar" "=" self.id)
                             (, "date" "=" date)]
                          :limit 1)]
      (bool holiday)
      )
    )
  
  )
