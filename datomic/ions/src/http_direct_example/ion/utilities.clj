(ns http-direct-example.ion.utilities
  (:require [datomic.ion :as ion]))

(defn response
  [status body]
  (let [allow-origin (:allow-origin (ion/get-env))]
    {:status  status
     :headers {"content-type"                     "application/transit+json"
               "access-control-allow-origin"      allow-origin
               "access-control-allow-credentials" "true"}
     :body    body}))
