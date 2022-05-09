#setdep @previous@

File {
  Grid=      "@tdr@"
  Current=   "@plot@"
  Plot=      "@tdrdat@"
  Output=    "@log@"
}

Electrode {
  { Name = "gate_contact" Voltage = 0 }
  { Name = "source_contact" Voltage = 0 }
  { Name = "drain_contact" Voltage = 0 }
  { Name = "substrate_contact" Voltage = @Vbs@ }
}

Physics (RegionInterface="gate_oxide/substrate") {
    Traps(
        FixedCharge Conc = @Qss@
    )
}
Physics (Material = "Silicon") {
    Mobility(
        Enormal (Lombardi InterfaceCharge)
        PhuMob HighFieldSaturation
    )
}
Physics {
  Fermi
  Mobility(
    DopingDep
  )
  Recombination (SRH(DopingDependence) Auger)
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
 Iterations = 20
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
    InitialStep = 0.05 Increment = 1.3	
    Minstep = 1.e-6     Maxstep = 0.05	
    Goal { Name = "drain_contact" Voltage = @Vds@ }  
    )   
      {
        Coupled { Poisson Electron Hole }
      }
 Plot (FilePrefix = "n@node@_gate_")
 NewCurrentPrefix = "VgsIds_"
  Quasistationary (
    InitialStep = 0.05 Increment = 1.3	
  Minstep = 1.e-6     Maxstep = 0.05	
  Goal { Name = "gate_contact" Voltage = @Vgs@ }  
 ) {
       Coupled { Poisson Electron Hole }
 }
}