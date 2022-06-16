(sde:clear)

(define Fin_width @Fin_width@)
(define Fin_height @Fin_height@)
(define Lspf @Lspf@)
(define LGB @LGB@)
(define Lspb @Lspb@)
(define Tsi @Tsi@)
(define Ls @Ls@)
(define Toxf @Toxf@)
(define Toxb @Toxb@)
(define Fg_width @Fg_width@)
(define Bg_width @Bg_width@)
(define Gate_height @Gate_height@)
(define GOh @GOh@)

(define substrate_edge_top_x (+ Fg_width (+ Tsi Bg_width)))
(define substrate_edge_top_y (+ Ls (+ Lspb (+ LGB(+ Ls Lspf)))))
(define substrate_thickness 0.1)
(define substrate_edge_top_z substrate_thickness)
(define substrate_doping @Nbody@)

(define buried_oxide_thickness 0.07)
(define buried_oxide_edge_top_x substrate_edge_top_x)
(define buried_oxide_edge_top_y substrate_edge_top_y)
(define buried_oxide_edge_top_z (+ buried_oxide_thickness substrate_edge_top_z))

(define source_edge_x (- (/ substrate_edge_top_x 2) (/ Fin_width 2)))
(define source_edge_y 0)
(define source_edge_z buried_oxide_edge_top_z)

(define source_edge_top_x (+ (/ substrate_edge_top_x 2) (/ Fin_width 2)))
(define source_edge_top_y Ls)
(define source_edge_top_z (+ buried_oxide_edge_top_z Fin_height))

(define asource_edge_x (+ source_edge_x (/ (- Fin_width Tsi) 2)))
(define asource_edge_y source_edge_top_y)
(define asource_edge_z source_edge_z)

(define asource_edge_top_x (+ asource_edge_x Tsi))
(define asource_edge_top_y (+ asource_edge_y Lspb))
(define asource_edge_top_z source_edge_top_z)

(define drain_edge_x source_edge_x)
(define drain_edge_y (+ (+ (+ Ls Lspf) LGB) Lspb))
(define drain_edge_z source_edge_z)

(define drain_edge_top_x source_edge_top_x)
(define drain_edge_top_y (+ drain_edge_y Ls))
(define drain_edge_top_z source_edge_top_z)

(define adrain_edge_x asource_edge_x)
(define adrain_edge_y (+ asource_edge_top_y LGB))
(define adrain_edge_z source_edge_z)

(define adrain_edge_top_x asource_edge_top_x)
(define adrain_edge_top_y (+ adrain_edge_y Lspf))
(define adrain_edge_top_z source_edge_top_z)

(define channel_edge_x asource_edge_x)
(define channel_edge_y asource_edge_top_y)
(define channel_edge_z source_edge_z)

(define channel_edge_top_x adrain_edge_top_x)
(define channel_edge_top_y adrain_edge_y)
(define channel_edge_top_z source_edge_top_z)

(define spacer_l_edge_x source_edge_x)
(define spacer_l_edge_y asource_edge_y)
(define spacer_l_edge_z source_edge_z)

(define spacer_l_edge_top_x source_edge_top_x)
(define spacer_l_edge_top_y asource_edge_top_y)
(define spacer_l_edge_top_z source_edge_top_z)

(define spacer_r_edge_x spacer_l_edge_x)
(define spacer_r_edge_y adrain_edge_y)
(define spacer_r_edge_z source_edge_z)

(define spacer_r_edge_top_x spacer_l_edge_top_x)
(define spacer_r_edge_top_y adrain_edge_top_y)
(define spacer_r_edge_top_z source_edge_top_z)

(define f_gate_oxide_edge_x (- channel_edge_x Toxf))
(define f_gate_oxide_edge_y channel_edge_y)
(define f_gate_oxide_edge_z channel_edge_z)

(define f_gate_oxide_edge_top_x adrain_edge_x)
(define f_gate_oxide_edge_top_y adrain_edge_y)
(define f_gate_oxide_edge_top_z source_edge_top_z)

(define b_gate_oxide_edge_x asource_edge_top_x)
(define b_gate_oxide_edge_y asource_edge_top_y)
(define b_gate_oxide_edge_z source_edge_z)

(define b_gate_oxide_edge_top_x (+ channel_edge_top_x Toxb))
(define b_gate_oxide_edge_top_y channel_edge_top_y)
(define b_gate_oxide_edge_top_z source_edge_top_z)

(define t_gate_oxide_edge_x channel_edge_x)
(define t_gate_oxide_edge_y channel_edge_y)
(define t_gate_oxide_edge_z source_edge_top_z)

(define t_gate_oxide_edge_top_x channel_edge_top_x)
(define t_gate_oxide_edge_top_y channel_edge_top_y)
(define t_gate_oxide_edge_top_z (+ source_edge_top_z GOh))

(define gate_edge_x 0)
(define gate_edge_y channel_edge_y)
(define gate_edge_z source_edge_z)

(define gate_edge_top_x substrate_edge_top_x)
(define gate_edge_top_y channel_edge_top_y)
(define gate_edge_top_z source_edge_top_z)

(define t_gate_edge_x (/ (+ spacer_l_edge_x f_gate_oxide_edge_x) 2))
(define t_gate_edge_y channel_edge_y)
(define t_gate_edge_z channel_edge_top_z)

(define t_gate_edge_top_x (/ (+ drain_edge_top_x b_gate_oxide_edge_top_x) 2))
(define t_gate_edge_top_y channel_edge_top_y)
(define t_gate_edge_top_z (+ t_gate_oxide_edge_top_z Gate_height))

(define Ngate @Ngate@)
(define Nsource @Ns@)
(define Ndrain @Nd@)

; make silicon substrate
(sdegeo:create-cuboid (position 0 0 0) (position substrate_edge_top_x substrate_edge_top_y substrate_edge_top_z) "Silicon" "substrate")

; doping substrate
(sdedr:define-constant-profile "substrate_dop" "BoronActiveConcentration" substrate_doping)
(sdedr:define-constant-profile-region "substrate_dop" "substrate_dop" "substrate")

; make substrate contact
(sdegeo:define-contact-set "substrate_contact" 4 (color:rgb 0 1 1) "##")
(sdegeo:set-current-contact-set "substrate_contact")
(sdegeo:set-contact-faces (list (car (find-face-id (position (/ substrate_edge_top_x 2) (/ substrate_edge_top_y 2) 0)))) "substrate_contact")

; make buried oxide
(sdegeo:create-cuboid (position 0 0 substrate_edge_top_z) (position buried_oxide_edge_top_x buried_oxide_edge_top_y buried_oxide_edge_top_z) "Oxide" "buried_oxide")

; make Source geometry
(sdegeo:create-cuboid (position source_edge_x source_edge_y source_edge_z) (position source_edge_top_x source_edge_top_y source_edge_top_z ) "Silicon" "source")

; make added Source geometry
(sdegeo:create-cuboid (position asource_edge_x asource_edge_y asource_edge_z) (position asource_edge_top_x asource_edge_top_y asource_edge_top_z) "Silicon" "asource")

; make left spacer
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-cuboid (position spacer_l_edge_x spacer_l_edge_y spacer_l_edge_z) (position spacer_l_edge_top_x spacer_l_edge_top_y spacer_l_edge_top_z) "Nitride" "left_spacer")

; doping source
(sdedr:define-refeval-window "RefEvalWin_s" "Polygon" (list (position source_edge_x source_edge_y source_edge_top_z) (position spacer_l_edge_x spacer_l_edge_y source_edge_top_z) 
(position asource_edge_x asource_edge_y source_edge_top_z) (position channel_edge_x channel_edge_y source_edge_top_z) (position asource_edge_top_x asource_edge_top_y source_edge_top_z) 
(position asource_edge_top_x asource_edge_y source_edge_top_z) (position source_edge_top_x source_edge_top_y source_edge_top_z) 
(position source_edge_top_x source_edge_y source_edge_top_z) (position source_edge_x source_edge_y source_edge_top_z))) 

(sdedr:define-gaussian-profile "Gauss.s" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" Nsource 
"ValueAtDepth" substrate_doping "Depth" Fin_height "Gauss" "Factor" 0.2)
(sdedr:define-analytical-profile-placement "Place.s" "Gauss.s" "RefEvalWin_s" "Positive" "NoRepalce" "Eval")

; make source contact

(sdegeo:define-contact-set "source_contact" 4 (color:rgb 1 1 0) "##")
(sdegeo:set-current-contact-set "source_contact")
(sdegeo:set-contact-faces (list (car (find-face-id (position (/ (+ source_edge_x source_edge_top_x) 2) (/ (+ source_edge_y source_edge_top_y) 2) source_edge_top_z)))) "source_contact")

; make Drain geometry
(sdegeo:create-cuboid (position drain_edge_x drain_edge_y drain_edge_z) (position drain_edge_top_x drain_edge_top_y drain_edge_top_z ) "Silicon" "drain")

; make added Drain geometry
(sdegeo:create-cuboid (position adrain_edge_x adrain_edge_y adrain_edge_z) (position adrain_edge_top_x adrain_edge_top_y adrain_edge_top_z) "Silicon" "adrain")

; make right spacer
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-cuboid (position spacer_r_edge_x spacer_r_edge_y spacer_r_edge_z) (position spacer_r_edge_top_x spacer_r_edge_top_y spacer_r_edge_top_z) "Nitride" "right_spacer")

; doping drain
(sdedr:define-refeval-window "RefEvalWin_d" "Polygon" (list (position drain_edge_x drain_edge_top_y drain_edge_top_z) (position drain_edge_x drain_edge_y drain_edge_top_z) 
(position adrain_edge_x drain_edge_y drain_edge_top_z) (position adrain_edge_x adrain_edge_y drain_edge_top_z) (position channel_edge_top_x channel_edge_top_y drain_edge_top_z) 
(position adrain_edge_top_x adrain_edge_top_y drain_edge_top_z) (position drain_edge_top_x drain_edge_y drain_edge_top_z) (position drain_edge_top_x drain_edge_top_y drain_edge_top_z)
(position drain_edge_x substrate_edge_top_y drain_edge_top_z)))

(sdedr:define-gaussian-profile "Gauss.d" "PhosphorusActiveConcentration" "PeakPos" 0 "PeakVal" Ndrain 
"ValueAtDepth" substrate_doping "Depth" Fin_height "Gauss" "Factor" 0.2)
(sdedr:define-analytical-profile-placement "Place.d" "Gauss.d" "RefEvalWin_d" "Both" "NoRepalce" "Eval")

; make drain contact

(sdegeo:define-contact-set "drain_contact" 4 (color:rgb 0 1 1) "##")
(sdegeo:set-current-contact-set "drain_contact")
(sdegeo:set-contact-faces (list (car (find-face-id (position (/ (+ drain_edge_x drain_edge_top_x) 2) (/ (+ drain_edge_y drain_edge_top_y) 2) drain_edge_top_z)))) "drain_contact")

; make Channel geometry
(sdegeo:create-cuboid (position channel_edge_x channel_edge_y channel_edge_z) (position channel_edge_top_x channel_edge_top_y channel_edge_top_z ) "Silicon" "channel")

; doping channel
(sdedr:define-constant-profile "channel_dop" "BoronActiveConcentration" substrate_doping)
(sdedr:define-constant-profile-region "channel_dop" "channel_dop" "channel")

; make front gate oxide 
(sdegeo:create-cuboid (position f_gate_oxide_edge_x f_gate_oxide_edge_y f_gate_oxide_edge_z) (position f_gate_oxide_edge_top_x f_gate_oxide_edge_top_y f_gate_oxide_edge_top_z) "SiO2" "fgate_oxide")

; make back gate oxide
(sdegeo:create-cuboid (position b_gate_oxide_edge_x b_gate_oxide_edge_y b_gate_oxide_edge_z) (position b_gate_oxide_edge_top_x b_gate_oxide_edge_top_y b_gate_oxide_edge_top_z) "SiO2" "bgate_oxide")

; make top gate oxide 
(sdegeo:create-cuboid (position t_gate_oxide_edge_x t_gate_oxide_edge_y t_gate_oxide_edge_z) (position t_gate_oxide_edge_top_x t_gate_oxide_edge_top_y t_gate_oxide_edge_top_z) "SiO2" "tgate_oxide")

; make bottom gate
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-cuboid (position gate_edge_x gate_edge_y gate_edge_z) (position gate_edge_top_x gate_edge_top_y gate_edge_top_z) "PolySilicon" "bottom_gate")

; make top gate
(sdegeo:create-cuboid (position t_gate_edge_x t_gate_edge_y t_gate_edge_z) (position t_gate_edge_top_x t_gate_edge_top_y t_gate_edge_top_z) "PolySilicon" "top_gate")

; doping gate
(sdedr:define-constant-profile "gate_dop" "BoronActiveConcentration" Ngate)
(sdedr:define-constant-profile-material "gate_dop" "gate_dop" "PolySilicon")

; make gate contact

(sdegeo:define-contact-set "gate_contact" 4 (color:rgb 0 0 1) "##")
(sdegeo:set-current-contact-set "gate_contact")
(sdegeo:set-contact-faces (list (car (find-face-id (position (/ (+ channel_edge_x channel_edge_top_x) 2) (/ (+ channel_edge_y channel_edge_top_y) 2) t_gate_edge_top_z)))) "gate_contact")

; build substrate mesh

(define res_max 0.05)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max res_max res_min res_min res_min )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")

; build channel mesh

(sdedr:define-refeval-window "RefWin.all" "cuboid" (position asource_edge_x asource_edge_y source_edge_z) (position adrain_edge_top_x adrain_edge_top_y adrain_edge_top_z))
(sdedr:define-refinement-size "RefDef.all" 0.01 0.01 0.01 0.001 0.001 0.001 )
(sdedr:define-refinement-function "RefDef.all" "DopingConcentration" "MaxTransDiff" 1)
(sdedr:define-refinement-placement "PlaceRF.all" "RefDef.all" "RefWin.all")

; build gate mesh
(sdedr:define-refinement-size "global-mesh-size" res_max res_max res_max res_min res_min res_min )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "PolySilicon")

; build gate oxide mesh
(sdedr:define-refinement-size "global-mesh-size" 0.005 0.005 0.005 0.001 0.001 0.001 )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "SiO2")

; build buried oxide mesh
(sdedr:define-refinement-size "global-mesh-size" res_max res_max res_max res_min res_min res_min )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Oxide")

; build Nitride mesh
(sdedr:define-refinement-size "global-mesh-size" res_max res_max res_max res_min res_min res_min )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Nitide")

(sde:build-mesh "n@node@")
