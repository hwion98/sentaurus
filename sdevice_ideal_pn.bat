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
     DopingDep 	//doping dependent
     HighFieldSaturation(GradQuasiFermi)	//saturation하면 더 이상 x
  )

  EffectiveIntrinsicDensity (
    BandGapNarrowing (oldSlotboom)	//매뉴얼에서 여러가지 중 하나 고르기
  )
}

Plot {
  TotalCurrent/Vector eCurrent/Vector hCurrent/Vector		//벡터 값들은 벡터로
  ElectricField/Vector Potential SpaceCharge
  edensity hDensity	//스칼라는 스칼라로
  eQuasiFermi hQuasiFermi
  Potential Doping SpaceCharge
  eMobility hMobility
  Donorconcentration AcceptorConcentration
  Doping
  eVelocity hVelocity
  conductionband valenceband
}

Math {

 Extrapolate	//여러가지 방법 들중 고르기
 Derivatives
 ExitOnFailure	//실패하면 끝내기 안하면 존나 계산 함

 Digits = 5	//자리수
 ErrRef(electron) = 1e8
 ErrRef(hole) = 1e8
 
 Iterations = 10		//iteration너무 많이 하면 너무 오래 걸림
 RelErrControl
 Method = pardiso	//여러가지 중 고르기
 NotDamped = 100
 RHSMin = 1e-8
 EquilibriumSolution(Iterations=100)	//앞에서 설정한 값(0V) 이거는 특별히 iteration많이

 NumberOfThreads = 4	//cpu thread 몇 개 사용하기(라이선스 하나당 스레드 4개) 그냥 바꾸지 말기
 ParallelLicense (Wait)
 Wallclock
}

Solve {
  Coupled (Iterations = 100) { Poisson }	//사용하는 equation
  Coupled (Iterations = 100) { Poisson Electron Hole } 	//이걸 해서 나온값이 equilibrium 값 
  Plot ( FilePrefix = "n@node@_init" )	//

  Quasistationary (	//p contact에 bias
  InitialStep = 1e-3 Increment = 1.41	//시작 간격, 성공하면 스텝을 키우는 정도 실패하면 줄어듬
  Minstep = 1e-3     Maxstep = 0.1	//여기까지 내려감, 여기까지만 올라감
  Goal { Name = "p_contact" Voltage = @Vp@ }	//@Vp@ sde parameter 설정으로 할 수 있음, 해당 노드의 값으로 설정됨 ex) n4:0.7  
 ) {
       Coupled { Poisson Electron Hole }
 }
