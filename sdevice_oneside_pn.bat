<<<<<<< HEAD
#setdep @previous@

Device "PN" {

 File {
  Grid=      "@tdr@"
  Plot=      "@tdrdat@"
  Parameter=    "@parameter@"
  Current=   "@plot@"
}

 Electrode {
  { Name = "p_contact" Voltage = 0 }
  { Name = "n_contact" Voltage = 0 }
}

  Physics {

  Fermi
  Mobility(
     DopingDep
     HighFieldSaturation(GradQuasiFermi)
  )
  Recombination (SRH(DopingDependence) Auger)
  EffectiveIntrinsicDensity (
    BandGapNarrowing (oldSlotboom)
  )
  }
}

Plot {
  TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  ElectricField/Vector Potential SpaceCharge
  edensity hDensity
  eQuasiFermi hQuasiFermi
  Potential Doping SpaceCharge
  eMobility hMobility
  Donorconcentration AcceptorConcentration
  Doping
  eVelocity hVelocity
  conductionband valenceband
  SRH Auger      
}

Math {

 Extrapolate
 Derivatives
 ExitOnFailure

 Digits = 5
 ErrRef(electron) = 1e8
 ErrRef(hole) = 1e8
 
 Iterations = 20
 RelErrControl
 Method = pardiso
 NotDamped = 100
 RHSMin = 1e-8
 EquilibriumSolution(Iterations=100)

 NumberOfThreads = 8
 ParallelLicense (Wait)
 Wallclock
}

File {
  Output  = "@log@"
  ACExtract  =  "@acplot@"
}

System {
  *-Physical devices:
  PN pn1 ( "p_contact" =pp  "n_contact" =nn )

  *-Lumped elements:
  Vsource_pset vpp (pp 0) { dc = 0.0 }
  Vsource_pset vnn (nn 0) { dc = 0.0 }
}
Solve {
  Coupled (Iterations = 100) { Poisson }
  Coupled (Iterations = 100) { Poisson Electron Hole }
  Plot ( FilePrefix = "n@node@_init" )

  NewCurrentPrefix=""
  Quasistationary (
    InitialStep=0.01 Increment=1.3
    MaxStep = 0.05 Minstep = 1.e-5
    Goal { Parameter = vpp.dc Voltage = -3.0 }
 ) { ACCoupled ( 
   StartFrequency=1e6   EndFrequency=1e6 NumberOfPoints=1 Decade
   Node(pp nn) Exclude(vpp vnn)
   ACCompute ( Time = (Range = (0 1) Intervals = 30))
 ) { Poisson Electron Hole }
 }
}
