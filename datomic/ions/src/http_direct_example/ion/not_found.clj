(ns http-direct-example.ion.not-found
  (:require [datomic.ion.cast :as cast]
            [http-direct-example.ion.utilities :as u]))

(defn handler
  [req]
  (cast/event {:msg "NotFound" ::req req})
  (u/response 404
              {}))
