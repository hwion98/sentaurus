
(sde:clear)
(sde:set-process-up-direction "+z")
;geometry

(sdegeo:create-rectangle (position 0 0 0) (position 1 0.2 0) "Silicon" "p_region")
(sdegeo:create-rectangle (position 0 0.2 0) (position 1 2.2 0) "Silicon" "n_region")

;contact
(sdegeo:define-contact-set "p_contact" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "p_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 0.5 0 0)))) "p_contact")

(sdegeo:define-contact-set "n_contact" 4 (color:rgb 0 1 0) "##")
(sdegeo:set-current-contact-set "n_contact")
(sdegeo:set-contact-edges (list (car (find-edge-id (position 0.5 2.2 0)))) "n_contact")

;doping

(sdedr:define-constant-profile "p_dop" "BoronActiveConcentration" 1e20)
(sdedr:define-constant-profile-region "p_dop" "p_dop" "p_region")

(sdedr:define-constant-profile "n_dop" "PhosphorusActiveConcentration" 1e16)
(sdedr:define-constant-profile-region "n_dop" "n_dop" "n_region")

;mesh
(define res_max 0.1)
(define res_min 0.01)

(sdedr:define-refinement-size "global-mesh-size" res_max res_max 0 res_min res_min 0 )
(sdedr:define-refinement-material "global-mesh" "global-mesh-size" "Silicon")

(sdedr:define-refeval-window "junction-mesh-region" "rectangle" (position 0 0.1 0) (position 1 0.3 0))
(sdedr:define-refinement-size "junction-mesh-size" res_min res_min 0 0.005 0.005 0 )
(sdedr:define-refinement-placement "junction-mesh" "junction-mesh-size" "junction-mesh-region")

(sde:build-mesh "n@node@")
