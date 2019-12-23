(ns http-direct-example.ion.proxy
  (:require [bidi.bidi :as bidi]
            [clojure.string :as cs]
            [http-direct-example.ion.resource :as resource]
            [http-direct-example.ion.not-found :as not-found]))

(def ^:private routes
  {:get ["/"
         [["resource" resource/handler]
          [true not-found/handler]]]})

(defn handler
  [req]
  (let [{:keys [request-method uri]} req
        route (bidi/match-route (get routes request-method)
                                (cs/replace uri #"/datomic" ""))
        handle (:handler route)]
    (handle req)))
