(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?l1 - location ?l2 - location ?r - robot)
      :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (no-robot ?l2))
      :effect (and (at ?r ?l2) (no-robot ?l1) (not (no-robot ?l2)) (not (at ?r ?l1)))
    )

    (:action robotMoveWithPallette
      :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (at ?p ?l1) (no-robot ?l2) (no-pallette ?l2))
      :effect (and (at ?r ?l2) (at ?p ?l2) (has ?r ?p) (no-robot ?l1) (no-pallette ?l1) (not (at ?r ?l1)) (not (no-robot ?l2)) (not (at ?p ?l1)) (not (no-pallette ?l2)))
    )

    (:action moveItemFromPalletteToShipment
      :parameters (?sh - shipment ?l - location ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (contains ?p ?si) (not (complete ?sh)) (started ?sh) (packing-at ?sh ?l) (not (available ?l)) (ships ?sh ?o) (at ?p ?l) (packing-location ?l) (orders ?o ?si))
      :effect (and (includes ?sh ?si) (not (contains ?p ?si)))
    )

    (:action completeShipment
      :parameters (?sh - shipment ?o - order ?l - location)
      :precondition (and (started ?sh) (packing-location ?l) (packing-at ?sh ?l) (ships ?sh ?o) (not (available ?l)) (not (complete ?sh)))
      :effect (and (available ?l) (complete ?sh))
    )

)
