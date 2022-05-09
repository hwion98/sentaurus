
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
  Recombination (SRH(DopingDependence) Auger Avalanche(GradQuasiFermi) Band2Band(Model= NonLocalPath))  //recombination
  EffectiveIntrinsicDensity (
    BandGapNarrowing (oldSlotboom)  //oldSlotboom이라는 방식 여러개중 고르기
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

  SRH Band2Band Auger
  ImpactIonization eImpactIonization hImpactIonization
  eIonIntegral hIonIntegral MeanIonIntegral eAlphaAvalanche hAlphaAvalanche
}

CurrentPlot {
  ImpactIonization (Integrate(Semiconductor))
}

Math {

 Extrapolate
 Derivatives
 ExitOnFailure

 Digits = 5 /소숫점 자리수
 ErrRef(electron) = 1e8
 ErrRef(hole) = 1e8
 
 Iterations = 10  //iteration너무 많으면 에러남
 RelErrControl
 Method = pardiso
 NotDamped = 100
 RHSMin = 1e-8
 EquilibriumSolution(Iterations=100)

 NumberOfThreads = 8  //사용하는 threads 4개가 최대
 ParallelLicense (Wait)
 Wallclock

 ComputeIonizationIntegrals ( )
 BreakAtIonIntegral(1 2)
 AvalPostProcessing

 Transient=BE
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
