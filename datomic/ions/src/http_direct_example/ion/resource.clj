(ns http-direct-example.ion.resource
  (:require [datomic.ion.cast :as cast]
            [http-direct-example.ion.utilities :as u]))

(defn handler
  [req]
  (cast/event {:msg "Resource" ::req req})
  (u/response 200
              {}))
