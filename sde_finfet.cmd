(sde:clear)

(define Fin_width @Fin_width@)
(define Fin_height @Fin_height@)
(define Lspf @Lspf@)
(define LGB @LGB@)
(define Lspb @Lspb@)
(define Tsi @Tsi@)
(define Ls 0.3)
(define Toxf @Toxf@)
(define Toxb @Toxb@)

(define substrate_edge_top_x 2)
(define substrate_edge_top_y 2)
(define substrate_thickness 1.5)
(define substrate_edge_top_z substrate_thickness)
(define substrate_doping @Nbody@)

(define buried_oxide_thickness 0.5)
(define buried_oxide_edge_top_x substrate_edge_top_x)
(define buried_oxide_edge_top_y substrate_edge_top_y)
(define buried_oxide_edge_top_z (+ buried_oxide_thickness substrate_edge_top_z))

(define source_edge_x (- (/ substrate_edge_top_x 2) (/ Fin_width 2)))
(define source_edge_y 0)
(define source_edge_z buried_oxide_edge_top_z)

(define source_edge_top_x (+ (/ substrate_edge_top_x 2) (/ Fin_width 2)))
(define source_edge_top_y Ls)
(define source_edge_top_z (+ buried_oxide_edge_top_z Fin_height))

(define drain_edge_x source_edge_x)
(define drain_edge_y (+ (+ (+ Ls Lspf) LGB) Lspb))
(define drain_edge_z source_edge_z)

(define drain_edge_top_x source_edge_top_x)
(define drain_edge_top_y (+ drain_edge_y Ls))
(define drain_edge_top_z source_edge_top_z)

(define channel_edge_x (- (/ substrate_edge_top_x 2) (/ Tsi 2)))
(define channel_edge_y source_edge_top_y)
(define channel_edge_z source_edge_z)

(define channel_edge_top_x (+ (/ substrate_edge_top_x 2) (/ Tsi 2)))
(define channel_edge_top_y drain_edge_y)
(define channel_edge_top_z drain_edge_top_z)

; make silicon substrate
(sdegeo:create-cuboid (position 0 0 0) (position substrate_edge_top_x substrate_edge_top_y substrate_edge_top_z) "Silicon" "substrate")

; doping substrate
(sdedr:define-constant-profile "substrate_dop" "BoronActiveConcentration" substrate_doping)
(sdedr:define-constant-profile-region "substrate_dop" "substrate_dop" "substrate")

; make buried oxide
(sdegeo:create-cuboid (position 0 0 substrate_edge_top_z) (position buried_oxide_edge_top_x buried_oxide_edge_top_y buried_oxide_edge_top_z) "SiO2" "buried_oxide")

; make Source geometry
(sdegeo:create-cuboid (position source_edge_x source_edge_y source_edge_z) (position source_edge_top_x source_edge_top_y source_edge_top_z ) "Silicon" "source")

; make Drain geometry
(sdegeo:create-cuboid (position drain_edge_x drain_edge_y drain_edge_z) (position drain_edge_top_x drain_edge_top_y drain_edge_top_z ) "Silicon" "drain")

; make Channel geometry
(sdegeo:create-cuboid (position channel_edge_x channel_edge_y channel_edge_z) (position channel_edge_top_x channel_edge_top_y channel_edge_top_z ) "Silicon" "channel")

; make spacer
(sdegeo:create-cuboid (position drain_edge_x (- drain_edge_y Lspf) drain_edge_z) (position (- drain_edge_x (/ (- Fw Tsi) 2)) channel_edge_top_y drain_edge_top_z) "Silicon" "spacer1")
(sdegeo:create-cuboid (position source_edge_x (+ source_edge_y Lspf) source_edge_z) (position (- drain_edge_x (/ (- Fw Tsi) 2)) (+ (+ source_edge_y Lspf) Lspb) source_edge_top_z) "Silicon" "spacer2")
(sdegeo:create-cuboid (position (- source_edge_top_x (/ (- Fw Tsi) 2)) (+ source_edge_y Lspf) source_edge_z) (position source_edge_top_x (+ (+ source_edge_y Lspf) Lspb) source_edge_top_z) "Silicon" "spacer3")
(sdegeo:create-cuboid (position channel_edge_top_x (- drain_edge_y Lspf) drain_edge_z) (position drain_edge_top_x channel_edge_top_y drain_edge_top_z) "Silicon" "spacer4")

; make front-gate oxide
(sdegeo:create-cuboid (position (- channel_edge_x Toxf) (+ source_edge_y Lspb) source_edge_z) (position channel_edge_x (- drain_edge_y Lspf) channel_edge_top_z))
; make back-gate oxide
(sdegeo:create-cuboid (position (+ channel_edge_x Tsi) (+ source_edge_y Lspb) source_edge_z) (position (+ channel_edge_top_x Toxb) channel_edge_top_y channel_edge_top_z))
; make gate2

; make gate3

; doping source, drain


; build substrate mesh
(define res_max 0.1)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max res_max res_min res_min res_min )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")

(sde:build-mesh "n@node@")