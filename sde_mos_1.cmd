(sde:clear) 
(sde:set-process-up-direction "+z")

(define gate_oxide_thickness @tox@)
(define gate_length @Lch@)
(define contact_length 0.5)
(define gap 0.05)
(define substrate_doping @Nsub@)
(define substrate_thickness 2)
(define gate_thickness 0.5)

(define Gate_Oxide_height (- gate_oxide_thickness))
(define Gate_right (/ gate_length 2.0))
(define Gate_left (- Gate_right))
(define Gate_height(- Gate_Oxide_height gate_thickness))

(define Draincontact_left (+ Gate_right gap))
(define Draincontact_right (+ Draincontact_left contact_length))
(define Draincontact_middle (+ Draincontact_left (/ contact_length 2.0)))

(define Sourcecontact_left (- Draincontact_right))
(define Sourcecontact_right (- Draincontact_left))
(define Sourcecontact_middle (+ Sourcecontact_left (/ contact_length 2.0)))

;geometry

(sdegeo:create-rectangle (position Sourcecontact_left 0 0) (position Draincontact_right substrate_thickness 0) "Silicon" "substrate")
(sdegeo:create-rectangle (position Gate_left Gate_Oxide_height 0) (position Gate_right 0 0) "SiO2" "gate_oxide")
(sdegeo:create-rectangle (position Gate_left Gate_height 0) (position Gate_right Gate_Oxide_height 0) "PolySilicon" "gate")

;contact

(sdegeo:insert-vertex (position Gate_left Gate_height 0))
(sdegeo:insert-vertex (position Gate_right Gate_height 0))

(sdegeo:define-contact-set "gate_contact" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-current-contact-set "gate_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 0 Gate_height 0)))) "gate_contact")

(sdegeo:insert-vertex (position Sourcecontact_left 0 0))
(sdegeo:insert-vertex (position Sourcecontact_right 0 0))

(sdegeo:define-contact-set "source_contact" 4 (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "source_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position Sourcecontact_middle 0 0)))) "source_contact")

(sdegeo:insert-vertex (position Draincontact_left 0 0))
(sdegeo:insert-vertex (position Draincontact_right 0 0))

(sdegeo:define-contact-set "drain_contact" 4 (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "drain_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position Draincontact_middle 0 0)))) "drain_contact")

(sdegeo:define-contact-set "substrate_contact" 4 (color:rgb 1 0 1) "##")
(sdegeo:set-current-contact-set "substrate_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 0 substrate_thickness 0)))) "substrate_contact")

;doping

(sdedr:define-constant-profile "gate_dop" "BoronActiveConcentration" 1e20)
(sdedr:define-constant-profile-region "gate_dop" "gate_dop" "gate")

(sdedr:define-constant-profile "substrate_dop" "BoronActiveConcentration" substrate_doping)
(sdedr:define-constant-profile-region "substrate_dop" "substrate_dop" "substrate")

(sdedr:define-refeval-window "BaseLine.nn" "Line" (position Sourcecontact_left 0 0) (position Sourcecontact_right 0 0))
(sdedr:define-gaussian-profile "Gauss.nn" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 1e20 
"ValueAtDepth" substrate_doping "Depth" 0.2 "Gauss" "Factor" 0.8)
(sdedr:define-analytical-profile-placement "Place.nn" "Gauss.nn" "BaseLine.nn" "Positive" "NoRepalce" "Eval")


(sdedr:define-refeval-window "BaseLine.nnn" "Line" (position Draincontact_left 0 0) (position Draincontact_right 0 0))
(sdedr:define-gaussian-profile "Gauss.nnn" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" 1e20 
"ValueAtDepth" substrate_doping "Depth" 0.2 "Gauss" "Factor" 0.8)
(sdedr:define-analytical-profile-placement "Place.nnn" "Gauss.nnn" "BaseLine.nnn" "Positive" "NoRepalce" "Eval")

;mesh

(define res_max 0.1)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max 0 res_min res_min 0 )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")

(sdedr:define-refeval-window "RefWin.all" "rectangle" (position Sourcecontact_left 0 0) (position Draincontact_right (/ substrate_thickness 2.0) 0))
(sdedr:define-refinement-size "RefDef.all" 0.05 0.05 0 0.005 0.005 0 )
(sdedr:define-refinement-function "RefDef.all" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "PlaceRF.all" "RefDef.all" "RefWin.all")

(sde:build-mesh "n@node@")