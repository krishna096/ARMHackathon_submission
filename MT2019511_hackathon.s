AREA    spiral, CODE, READONLY
	 IMPORT printMsg             
	 export __main	
	 ENTRY 
__main  function	
	    MOV R4, #3 ; for selecting spirals for R4=2 it makes spiral 1 and for r4=1 spiral 2(smaller radius)
		;mov r11, #0;
		
		
		
start   mov r11, #0
		VLDR.F32 S24,=0 ;angle starting value
		VLDR.F32 S16,=360; for spiral of 3 circles 
	 	VLDR.F32 S15,=10; incrementing theta by 30 degree 	            ;;;;;;;;;;;;;;debugginh 30 to 540 ;;;;;;;;;;
		sub r4, r4 ,#1 ;;;;;;;;;;;;;;debugggig;;;;;;;;;;;;;
		CMP R4, #0 
		beq stop
		
		CMP R4, #2 
		beq stl1
		
stl2  		MOV R8, #200 ; radius	
			MOV R5, #1800;MOV R0, #100 ; x 
			MOV R10,#2800;MOV R1, #100 ; y 
			b stl_

stl1    	MOV R8, #10 ; value of radius	
			MOV R5, #200;MOV R0, #100 ; x 
			MOV R10,#200;MOV R1, #100 ; y 
		
		
stl_	VMOV.F32 S19,R5; ; converting x value to floating point 
        VCVT.F32.U32 S19,S19; 
		VMOV.F32 S20,R10; converting y value to floating point 
        VCVT.F32.U32 S20,S20; 
		VMOV.F32 S12,R8; converting radius value to floating point 
        VCVT.F32.U32 S12,S12; 
		VMOV.F32 S17,S24
		BL sub1; subroutine
		VMUL.F32 S13,S12,S9; x = r*(cos)
		VMUL.F32 S14,S12,S0; y = r*(sin)
		VADD.F32 S21,S13,S19; 
		VADD.F32 S22,S14,S20 ; 
		VCVT.S32.F32 S21,S21
		VCVT.S32.F32 S22,S22
		VCVT.U32.F32 S17,S17
		VMOV.F32 R0,S17
		VMOV.F32 R1,S21
		VMOV.F32 R2,S22
		BL printMsg	 ;printing angle and X and Y co-ordinates. ;;;;;;;;;;;;;;;;;;;;;;;;debugginh commented;;;;;;;;;;;;;;;;;
		VCMP.F32 S24, S16
		vmrs APSR_nzcv, FPSCR ; ASA theta becomes 360 we jump to spiral and make theta equals to 0.
		
		;sub r4, r4 ,#1 ;;;;;;;;;;;;;;debugggig;;;;;;;;;;;;;
		BEQ spirl ;;;;;;;;;;;;;;;;;;;;;;;;start to stop ;;;;;;;;;;; debugginh;;;;;;;;;;;;;;; ;;;;;stop to spirl;;;;;;;
addl	VADD.F32 S24, S15, S24
		B inc_dec
		;ADD R8, R8, #1
		B stl_
		
spirl  	 cmp r11, #4 ; number of encirclement you want 
		 beq start 
		 
		 ADD R11,R11,#1
		 VLDR.F32 S24, = 0
		 b addl

inc_dec  cmp r4, #2 
		 ITE EQ
		 ADDEQ R8, R8, #3
		 SUBNE R8, R8, #1
		 B stl_
		
stop    B stop;  goto stop

sub1    MOV R0,#100; n ;;;;;;;;;;;;;;;;;;;;100 -------2 debugging -----------
        MOV R1,#1; i
        VLDR.F32 S0,=1;
        VLDR.F32 S1,=1;Temp 
	 	VLDR.F32 S7,=57; degress into radians 
		VDIV.F32 S2,S17,S7 ;  degress into radians 
		VMOV.F32 S1,S2; t=x 
		VMOV.F32 S0,S2; sum=x 
		VLDR.F32 S8,=1; t=1 
		VLDR.F32 S9,=1; 
		
itera   CMP R1,R0;Compare 'i' and 'n'
        BLE si_co;if i < n goto LOOP  
		BX lr ; else return from subroutine	


si_co  	VMOV.F32 S3,R1 ;converting i to floating point 
        VCVT.F32.U32 S3,S3  ;converting to unsigned floating number 32-bit
		VNMUL.F32 S4,S2,S2; -1*x*x
		MOV R9,#2
		MUL R2,R1,R9; 2i
		ADD R3,R2,#1; 2i+1 
		SUB R6,R2,#1; 2i-1 
		MUL R3,R2,R3; 2i*(2i+1)  
		MUL R7,R2,R6; 2i*(2i-1) 
        VMOV.F32 S5,R3; 2i*(2i+1)
		VMOV.F32 S10,R7; 2i*(2i-1)
        VCVT.F32.U32 S5,S5; (2i*(2i+1))
		VCVT.F32.U32 S10,S10;(2i*(2i-1))
		VDIV.F32 S6,S4,S5 ; -(x*x)/2i*(2i+1)
		VDIV.F32 S11,S4,S10 ; -(x*x)/2i*(2i-1)
 		VMUL.F32 S1,S1,S6; t=t*(-1)*(x*x)/2i*(2i+1)
		VMUL.F32 S8,S8,S11; t=t*(-1)*(x*x)/2i*(2i-1)
		VADD.F32 S0,S0,S1;result of Sine series 
		VADD.F32 S9,S9,S8;result of Cosine series
		ADD R1,R1,#1; increment the value of i by 1
		B itera;Again goto comparision
		
		endfunc
        end
