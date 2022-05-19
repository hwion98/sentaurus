(sde:clear) 
(sde:set-process-up-direction "+z")

(define base_left 0.3)
(define base_width 0.4)
(define base_right (+ base_left base_width))
(define base_middle (/ (+ base_left base_right) 2.0))
(define base_thickness @Tbase@)
(define base_doping_concentration @Nabase@)

(define emitter_left 0.9)
(define emitter_width 0.2)
(define emitter_right (+ emitter_left emitter_width))
(define emitter_middle (/ (+ emitter_left emitter_right) 2.0))
(define emitter_thickness @Temit@)
(define emitter_doping_concentration @Ndemit@)

(define collector_thickness @Tcol@)

(define epi_left 0.2)
(define epi_width 1)
(define epi_right (+ epi_left epi_width))
(define epi_thickness (+ collector_thickness (+ emitter_thickness base_thickness)))
(define epi_top (- epi_thickness))
(define epi_layer_doping @Ndepi@)

(define sinker_left (+ epi_right 0.3))
(define sinker_width 0.5)
(define sinker_right (+ sinker_left sinker_width))
(define sinker_doping_concentration @Ndsink@)

(define collector_left sinker_left)
(define collector_width sinker_width)
(define collector_right sinker_right)
(define collector_middle (/ (+ collector_left collector_right) 2.0))

(define substrate_thickness 2)
(define substrate_width 2.2)
(define substrate_left 0)
(define substrate_right (+ substrate_left substrate_width))
(define substrate_middle (/ (+ substrate_left substrate_right) 2.0))
(define substrate_top 0)
(define substrate_bottom (+ substrate_top substrate_thickness))
(define substrate_doping 1e16)

(define oxide_thickness epi_thickness)
(define oxide_width 2.2)
(define oxide_top epi_top)

; make_substrate
(sdegeo:create-rectangle (position substrate_left substrate_top 0) (position substrate_right substrate_bottom 0) "Silicon" "substrate")

; substrate_doping
(sdedr:define-constant-profile "substrate_dop" "BoronActiveConcentration" substrate_doping)
(sdedr:define-constant-profile-region "substrate_dop" "substrate_dop" "substrate")

;buried_layer_doping
(sdedr:define-refeval-window "BaseLine.buried_layer" "Line" (position epi_left substrate_top 0) (position sinker_right substrate_top 0))
(sdedr:define-gaussian-profile "Gauss.buried_layer" "PhosphorusActiveConcentration" "PeakPos" substrate_top "PeakVal" 5e19
"ValueAtDepth" substrate_doping "Depth" 0.3 "Gauss" "Length" 0.02)
(sdedr:define-analytical-profile-placement "Place.buried_layer" "Gauss.buried_layer" "BaseLine.buried_layer" "Positive" "NoRepalce" "Eval")

;create_epi_layer and oxide
(sdegeo:create-rectangle (position epi_left epi_top 0) (position epi_right substrate_top 0) "Silicon" "epi_layer")
(sdegeo:create-rectangle (position sinker_left epi_top 0) (position sinker_right substrate_top 0) "Silicon" "sinker")
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-rectangle (position 0 0 0) (position oxide_width oxide_top 0) "SiO2" "oxide")

;epi_layer doping

(sdedr:define-constant-profile "epi_dop" "PhosphorusActiveConcentration" epi_layer_doping)
(sdedr:define-constant-profile-region "epi_dop" "epi_dop" "epi_layer")

(sdedr:define-constant-profile "epi_dop2" "PhosphorusActiveConcentration" epi_layer_doping)
(sdedr:define-constant-profile-region "epi_dop2" "epi_dop2" "sinker")

; base_doping
(sdedr:define-refeval-window "BaseLine.base" "Line" (position epi_left epi_top 0) (position epi_right epi_top 0))
(sdedr:define-gaussian-profile "Gauss.base" "BoronActiveConcentration" "PeakPos" 0 "PeakVal" base_doping_concentration
"ValueAtDepth" epi_layer_doping "Depth" (+ base_thickness emitter_thickness) "Gauss" "Length" 0.02)
(sdedr:define-analytical-profile-placement "Place.base" "Gauss.base" "BaseLine.base" "Positive" "NoRepalce" "Eval")

; sinker_doping
(sdedr:define-refeval-window "BaseLine.sinker" "Line" (position sinker_left epi_top 0) (position sinker_right epi_top 0))
(sdedr:define-gaussian-profile "Gauss.sinker" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" sinker_doping_concentration
"ValueAtDepth" 1e17 "Depth" (+ epi_thickness 0.2) "Gauss" "Length" 0.02)
(sdedr:define-analytical-profile-placement "Place.sinker" "Gauss.sinker" "BaseLine.sinker" "Positive" "NoRepalce" "Eval")

;emitter_doping
(sdedr:define-refeval-window "BaseLine.emitter" "Line" (position emitter_left epi_top 0) (position emitter_right epi_top 0))
(sdedr:define-gaussian-profile "Gauss.emitter" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" emitter_doping_concentration
"ValueAtDepth" (* base_doping_concentration 0.37) "Depth" emitter_thickness "Gauss" "Length" 0.02)
(sdedr:define-analytical-profile-placement "Place.emitter" "Gauss.emitter" "BaseLine.emitter" "Positive" "NoRepalce" "Eval")

; make base contact

(sdegeo:insert-vertex (position base_left epi_top 0))
(sdegeo:insert-vertex (position base_right epi_top 0))

(sdegeo:define-contact-set "base_contact" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-current-contact-set "base_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position base_middle epi_top 0)))) "base_contact")

; make emitter contact

(sdegeo:insert-vertex (position emitter_left epi_top 0))
(sdegeo:insert-vertex (position emitter_right epi_top 0))

(sdegeo:define-contact-set "emitter_contact" 4 (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "emitter_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position emitter_middle epi_top 0)))) "emitter_contact")

; make collector contact

(sdegeo:insert-vertex (position collector_left epi_top 0))
(sdegeo:insert-vertex (position collector_right epi_top 0))

(sdegeo:define-contact-set "collector_contact" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "collector_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position collector_middle epi_top 0)))) "collector_contact")

; make substrate_contact

(sdegeo:define-contact-set "substrate_contact" 4 (color:rgb 1 0 1) "##")
(sdegeo:set-current-contact-set "substrate_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position substrate_middle substrate_bottom 0)))) "substrate_contact")

;mesh

(define res_max 0.1)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max 0 res_min res_min 0 )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")

(sdedr:define-refeval-window "RefWin.all" "rectangle" (position substrate_left epi_top 0) (position substrate_right 0.6 0))
(sdedr:define-refinement-size "RefDef.all" 0.05 0.05 0 0.005 0.005 0 )
(sdedr:define-refinement-function "RefDef.all" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "PlaceRF.all" "RefDef.all" "RefWin.all")

(sdedr:define-refeval-window "RefWin.all" "rectangle" (position emitter_left epi_top 0) (position emitter_right 0.6 0))
(sdedr:define-refinement-size "RefDef.all" 0.01 0.01 0 0.0001 0.0001 0 )
(sdedr:define-refinement-function "RefDef.all" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "PlaceRF.all" "RefDef.all" "RefWin.all")

(sde:build-mesh "n@node@")