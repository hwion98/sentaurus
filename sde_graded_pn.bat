<<<<<<< HEAD
(sde:clear)
(sde:set-process-up-direction "+z")

(define wafer_thick 2)

;geometry

(sdegeo:create-rectangle (position 0 0 0) (position 2 wafer_thick 0) "Silicon" "n_region")

;contact

(sdegeo:define-contact-set "n_contact" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 1 wafer_thick 0)))) "n_contact")

(sdegeo:insert-vertex (position 0.5 0 0))
(sdegeo:insert-vertex (position 1.5 0 0))

(sdegeo:define-contact-set "p_contact" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 1.0 0 0)))) "p_contact")

;doping

(sdedr:define-constant-profile "n_dop" "PhosphorusActiveConcentration" 1e16)
(sdedr:define-constant-profile-region "n_dop" "n_dop" "n_region")

(sdedr:define-refeval-window "BaseLine.pp" "Line" (position 0.5 0 0) (position 1.5 0 0))
(sdedr:define-gaussian-profile "Gauss.pp" "BoronActiveConcentration" "PeakPos" 0.0 "PeakVal" 1e20 ;peakpos=baseline
"ValueAtDepth" 1e16 "Depth" 0.1 "Gauss" "Factor" 0.8)
(sdedr:define-analytical-profile-placement "Place.pp" "Gauss.pp" "BaseLine.pp" "Positive" "NoRepalce" "Eval") ;positive diffused toward y+

;mesh

(define res_max 0.1)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max 0 res_min res_min 0 )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")
; mesh differ by doping differnces

(sdedr:define-refeval-window "RefWin.all" "rectangle" (position 0 0 0) (position 2 0.5 0))
(sdedr:define-refinement-size "RefDef.all" 0.05 0.05 0 0.005 0.005 0 )
(sdedr:define-refinement-function "RefDef.all" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "PlaceRF.all" "RefDef.all" "RefWin.all")

(sde:build-mesh "n@node@")
=======