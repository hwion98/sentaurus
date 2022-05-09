<<<<<<< HEAD
File {
  Grid=      "@tdr@"
  Current=   "@plot@"
  Plot=      "@tdrdat@"
  Output=    "@log@"
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
  Recombination (
     SRH(DopingDependence) Auger
  )
  EffectiveIntrinsicDensity (
    BandGapNarrowing (oldSlotboom)
  )
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
 
 Iterations = 10
 RelErrControl
 Method = pardiso
 NotDamped = 100
 RHSMin = 1e-8
 EquilibriumSolution(Iterations=100)

 NumberOfThreads = 4
 ParallelLicense (Wait)
 Wallclock
}

Solve {
  Coupled (Iterations = 100) { Poisson }
  Coupled (Iterations = 100) { Poisson Electron Hole }
  Plot ( FilePrefix = "n@node@_init" )

  Quasistationary (
  InitialStep = 1e-3 Increment = 1.41
  Minstep = 1e-3     Maxstep = 0.1
  Goal { Name = "p_contact" Voltage = @Vp@ }
 ) {
       Coupled { Poisson Electron Hole }
 }
}
; 다른 sdevice parameter 가져오려면 @parameter|sdevice(number)@ 이런식으로 해야함. ex)sdevice1에 있는 parameter Vp가져오려면 @Vp|sdevice1@
