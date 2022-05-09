#setdep @previous@

Device "MOS" {
    File {
      Grid=      "@tdr@"
      Plot=      "@tdrdat@"
      Parameter=    "@parameter@"
      Current=   "@plot@"
    }

    Electrode {
      { Name = "gate_contact" Voltage = 0 }
      { Name = "source_contact" Voltage = 0 }
      { Name = "drain_contact" Voltage = 0 }
      { Name = "substrate_contact" Voltage = 0 }
    }

    Physics {
      Fermi
      EffectiveIntrinsicDensity (oldSlotboom)   
      Mobility(
        DopingDep
      )
      Recombination (SRH( DopingDep TempDependence )) 
    }
} * End of Device{}

Plot {
    *--Density and Currents, etc
  edensity hDensity
  TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  eMobility hMobility
  eVelocity hVelocity
  eQuasiFermi 
  
  *--Temperature
  eTemperature Temperature * hTemperature

  *--Field and charges
  ElectricField/Vector Potential SpaceCharge

  *--Doping profiles
  Doping Donorconcentration AcceptorConcentration

  *--Generation and Recombination
  SRH Band2BandGeneration * Auger
  ImpactIonization eImpactIonization hImpactIonization

  *--Driving forces
  eGradQuasiFermi/Vector hGradQuasiFermi/Vector
  eEparallel hEparallel eENormal hENormal

  *--Band structure/Composition
  BandGap
  BandGapNarrowing
  Affinity
  Conductionband Valenceband
  eQuantumPotential    
}

Math {

    RelErrControl

    Digits = 5
    ErrRef(electron) = 1.e10
    ErrRef(hole) = 1.e10
    Iterations = 10
    NotDamped = 100
    Method = Blocked
    SubMethod = Super
    ACMethod = Blocked
    ACSubMethod = Super

    NumberOfThreads = 4
    ParallelLicense (Wait)
    Wallclock
}

File {
    Output=    "@log@"
    ACExtract=    "@acplot@"    
}

System {
    *-Physical Device:
    MOS nmos1 ("source_contact"=s "drain_contact"=d "gate_contact"=g "substrate_contact"=b )  
    *-Lumped elements:
    Vsource_pset vs (s 0) { dc = 0.0 }
    Vsource_pset vg (g 0) { dc = 0.0 }
    Vsource_pset vb (b 0) { dc = 0.0 }
    Vsource_pset vd (d 0) { dc = 0.0 }
}

Solve {
    NewCurrentPrefix = "init_"
    Coupled (Iterations = 100) { Poisson }	
    Coupled (Iterations = 100) { Poisson Electron Hole } 	 
    Plot ( FilePrefix = "n@node@_init" )    

    Quasistationary (
    InitialStep = 0.1 Increment = 1.3	
    Minstep = 1.e-4     Maxstep = 0.5	
    Goal { Parameter=vg.dc Voltage=@<-1*Vgs|sdevice>@ }  
    ) {
        Coupled { Poisson Electron Hole }
    }

 Plot (FilePrefix = "n@node@_0V_-3V")

 NewCurrentPrefix = ""
  Quasistationary (
    InitialStep = 0.1 Increment = 1.3	
    Minstep = 1.e-5     Maxstep = 0.05	
    Goal { Parameter=vg.dc Voltage=@Vgs|sdevice@ }  
    ) {ACCoupled (
        StartFrequency=1  EndFrequency=1 NumberOfPoints=1 Decade
        Node(s d g b) Exclude(vs vd vg vb)
        ACCompute (Time = (Range = (0 1) Intervals = 100))
        ) {
            Poisson Electron Hole
        }
    }
}