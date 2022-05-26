#setdep @previous@

File {
  Grid=      "@tdr@"
  Current=   "@plot@"
  Plot=      "@tdrdat@"
  Output=    "@log@"
}

Electrode {
  { Name = "base_contact" Voltage = 0 }
  { Name = "emitter_contact" Voltage = 0 }
  { Name = "collector_contact" Voltage = 0 }
  { Name = "substrate_contact" Voltage = 0 }
}

Physics {
  Fermi
  Mobility(
    DopingDep
    HighFieldSaturation(GradQuasiFermi)
  )
  Recombination (
    SRH(DopingDependence) 
    Auger
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
 ExitOnFailure
 RelErrControl

 Digits = 5
 Iterations = 10
 NotDamped = 100
 Method = pardiso

 NumberOfThreads = 4
 ParallelLicense (Wait)
 Wallclock
}


Solve {
  Coupled (Iterations = 100) { Poisson }	
  Coupled (Iterations = 100) { Poisson Electron Hole } 	 
  Plot ( FilePrefix = "n@node@_init" )

 Quasistationary (
    InitialStep = 0.01 Increment = 1.2	
  Minstep = 1.e-6     Maxstep = 0.08	
  Goal { Name = "emitter_contact" Voltage = @<-1*Vbe>@ }  
 ) {
       Coupled { Poisson Electron Hole }
 }

  Plot (FilePrefix = "n@node@_base_")
  NewCurrentPrefix = "VcbIc_"

 Quasistationary (
    InitialStep = 0.01 Increment = 1.2	
  Minstep = 1.e-6     Maxstep = 0.08	
  Goal { Name = "collector_contact" Voltage = @Vcb@ }  
 ) {
       Coupled { Poisson Electron Hole }
 }
}