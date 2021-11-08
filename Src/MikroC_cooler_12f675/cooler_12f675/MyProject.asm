
_fn_Init_Const:

;MyProject.c,26 :: 		void fn_Init_Const (void){
;MyProject.c,27 :: 		Const_Temp1 = EEPROM_Read (0x0);                //  30
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Temp1+0
;MyProject.c,28 :: 		Const_Temp2 = EEPROM_Read (0x1);                //  45
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Temp2+0
;MyProject.c,29 :: 		Const_Temp3 = EEPROM_Read (0x2);                //  60
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Temp3+0
;MyProject.c,30 :: 		Const_Temp4 = EEPROM_Read (0x3);                //поорог включения зуммера 75
	MOVLW      3
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Temp4+0
;MyProject.c,31 :: 		Const_Pwm1  = EEPROM_Read (0x4);                //   10
	MOVLW      4
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Pwm1+0
;MyProject.c,32 :: 		Const_Pwm2  = EEPROM_Read (0x5);                //   25
	MOVLW      5
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Pwm2+0
;MyProject.c,33 :: 		Const_Pwm3  = EEPROM_Read (0x6);                //   48
	MOVLW      6
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _Const_Pwm3+0
;MyProject.c,34 :: 		}
L_end_fn_Init_Const:
	RETURN
; end of _fn_Init_Const

_fn_Auto_Cooler:

;MyProject.c,40 :: 		void fn_Auto_Cooler(void){                                             //фукция авторегулировки оборотов
;MyProject.c,43 :: 		if(temperature >= Const_Temp1) {                                     //если температура больше первого уровня
	MOVF       _Const_Temp1+0, 0
	SUBWF      _temperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler0
;MyProject.c,46 :: 		if((temperature >= Const_Temp1) && (temperature < Const_Temp2) )  {     //если в пределах между первым и вторым уровнями...
	MOVF       _Const_Temp1+0, 0
	SUBWF      _temperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler3
	MOVF       _Const_Temp2+0, 0
	SUBWF      _temperature+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler3
L__fn_Auto_Cooler48:
;MyProject.c,47 :: 		if(set_Pwm == Const_Pwm2){                                          //если сейчас на втором уровне ШИМ...
	MOVF       _set_Pwm+0, 0
	XORWF      _Const_Pwm2+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_fn_Auto_Cooler4
;MyProject.c,48 :: 		if(temperature < (Const_Temp2-2)) set_Pwm=Const_Pwm1;            //гистерезис
	MOVLW      2
	SUBWF      _Const_Temp2+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSS      STATUS+0, 0
	DECF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__fn_Auto_Cooler51
	MOVF       R1+0, 0
	SUBWF      _temperature+0, 0
L__fn_Auto_Cooler51:
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler5
	MOVF       _Const_Pwm1+0, 0
	MOVWF      _set_Pwm+0
L_fn_Auto_Cooler5:
;MyProject.c,49 :: 		}
	GOTO       L_fn_Auto_Cooler6
L_fn_Auto_Cooler4:
;MyProject.c,51 :: 		set_Pwm=Const_Pwm1;                                              //иначе выставляем первый уровень ШИМ
	MOVF       _Const_Pwm1+0, 0
	MOVWF      _set_Pwm+0
L_fn_Auto_Cooler6:
;MyProject.c,54 :: 		}
	GOTO       L_fn_Auto_Cooler7
L_fn_Auto_Cooler3:
;MyProject.c,56 :: 		if((temperature >= Const_Temp2) && (temperature < Const_Temp3) )  {    //если в пределах между вторым и третим уровнями...
	MOVF       _Const_Temp2+0, 0
	SUBWF      _temperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler10
	MOVF       _Const_Temp3+0, 0
	SUBWF      _temperature+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler10
L__fn_Auto_Cooler47:
;MyProject.c,57 :: 		if(set_Pwm == Const_Pwm3){
	MOVF       _set_Pwm+0, 0
	XORWF      _Const_Pwm3+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_fn_Auto_Cooler11
;MyProject.c,58 :: 		if(temperature < (Const_Temp3-2)) set_Pwm=Const_Pwm2;
	MOVLW      2
	SUBWF      _Const_Temp3+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSS      STATUS+0, 0
	DECF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__fn_Auto_Cooler52
	MOVF       R1+0, 0
	SUBWF      _temperature+0, 0
L__fn_Auto_Cooler52:
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler12
	MOVF       _Const_Pwm2+0, 0
	MOVWF      _set_Pwm+0
L_fn_Auto_Cooler12:
;MyProject.c,59 :: 		}
	GOTO       L_fn_Auto_Cooler13
L_fn_Auto_Cooler11:
;MyProject.c,61 :: 		set_Pwm=Const_Pwm2;
	MOVF       _Const_Pwm2+0, 0
	MOVWF      _set_Pwm+0
L_fn_Auto_Cooler13:
;MyProject.c,63 :: 		}
	GOTO       L_fn_Auto_Cooler14
L_fn_Auto_Cooler10:
;MyProject.c,65 :: 		if(temperature >= Const_Temp3) {
	MOVF       _Const_Temp3+0, 0
	SUBWF      _temperature+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler15
;MyProject.c,66 :: 		set_Pwm=Const_Pwm3;
	MOVF       _Const_Pwm3+0, 0
	MOVWF      _set_Pwm+0
;MyProject.c,67 :: 		if(temperature > Const_Temp4)BUZZER=1;                         //если температура больше допустимой (Temp4) включаем зуммер.
	MOVF       _temperature+0, 0
	SUBWF      _Const_Temp4+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler16
	BSF        GPIO+0, 4
L_fn_Auto_Cooler16:
;MyProject.c,69 :: 		}
L_fn_Auto_Cooler15:
;MyProject.c,70 :: 		}
L_fn_Auto_Cooler14:
;MyProject.c,71 :: 		}
L_fn_Auto_Cooler7:
;MyProject.c,74 :: 		if(flag_Status_Cooler == 0){                              //если кулер не запущен...
	MOVF       _flag_Status_Cooler+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_fn_Auto_Cooler17
;MyProject.c,75 :: 		pwm_duty_b=45;                                      //делаем старт с максимальной скважностью ШИМ...
	MOVLW      45
	MOVWF      _pwm_duty_b+0
;MyProject.c,76 :: 		flag_Status_Cooler=1;                               //выставляем флаг,что кулер запущен
	MOVLW      1
	MOVWF      _flag_Status_Cooler+0
;MyProject.c,77 :: 		}
	GOTO       L_fn_Auto_Cooler18
L_fn_Auto_Cooler17:
;MyProject.c,79 :: 		pwm_duty_b=set_Pwm;                                  //иначе заполнение ШИМ ставим в соответствии с значением температуры
	MOVF       _set_Pwm+0, 0
	MOVWF      _pwm_duty_b+0
;MyProject.c,80 :: 		}
L_fn_Auto_Cooler18:
;MyProject.c,84 :: 		}
	GOTO       L_fn_Auto_Cooler19
L_fn_Auto_Cooler0:
;MyProject.c,86 :: 		if(temperature <(Const_Temp1-2)) {                        //если температура опустилась ниже первого уровня...
	MOVLW      2
	SUBWF      _Const_Temp1+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSS      STATUS+0, 0
	DECF       R1+1, 1
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__fn_Auto_Cooler53
	MOVF       R1+0, 0
	SUBWF      _temperature+0, 0
L__fn_Auto_Cooler53:
	BTFSC      STATUS+0, 0
	GOTO       L_fn_Auto_Cooler20
;MyProject.c,87 :: 		pwm_duty_b=0;                                           //выключаем кулер
	CLRF       _pwm_duty_b+0
;MyProject.c,88 :: 		flag_Status_Cooler=0;                                   // сбрасываем флаг
	CLRF       _flag_Status_Cooler+0
;MyProject.c,89 :: 		}
L_fn_Auto_Cooler20:
;MyProject.c,90 :: 		}
L_fn_Auto_Cooler19:
;MyProject.c,94 :: 		}
L_end_fn_Auto_Cooler:
	RETURN
; end of _fn_Auto_Cooler

_pwm1:

;MyProject.c,98 :: 		unsigned short pwm1 (unsigned short n ){       //функция программный ШИМ
;MyProject.c,104 :: 		switch(n) {                                     //переключатель определяет крайние положения ШИМ1
	GOTO       L_pwm121
;MyProject.c,105 :: 		case 0:
L_pwm123:
;MyProject.c,106 :: 		k = 0;
	CLRF       R1+0
;MyProject.c,107 :: 		break;
	GOTO       L_pwm122
;MyProject.c,108 :: 		case 50 :
L_pwm124:
;MyProject.c,109 :: 		k = 1;
	MOVLW      1
	MOVWF      R1+0
;MyProject.c,110 :: 		break;
	GOTO       L_pwm122
;MyProject.c,111 :: 		default:
L_pwm125:
;MyProject.c,114 :: 		if (pwmcycle <= n)                    // и устанавливает длинну импульса ШИМ1
	MOVF       R2+0, 0
	SUBWF      FARG_pwm1_n+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_pwm126
;MyProject.c,115 :: 		k = 1;
	MOVLW      1
	MOVWF      R1+0
	GOTO       L_pwm127
L_pwm126:
;MyProject.c,117 :: 		k = 0;
	CLRF       R1+0
L_pwm127:
;MyProject.c,118 :: 		}
	GOTO       L_pwm122
L_pwm121:
	MOVF       FARG_pwm1_n+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_pwm123
	MOVF       FARG_pwm1_n+0, 0
	XORLW      50
	BTFSC      STATUS+0, 2
	GOTO       L_pwm124
	GOTO       L_pwm125
L_pwm122:
;MyProject.c,120 :: 		if (++pwmcycle == 50 ) {              //  если отсчитали 50 циклов
	INCF       R2+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_pwm128
;MyProject.c,121 :: 		pwmcycle = 0;                       //     обнуляем счетчик циклов
	CLRF       R2+0
;MyProject.c,122 :: 		}
L_pwm128:
;MyProject.c,124 :: 		return k ;
	MOVF       R1+0, 0
	MOVWF      R0+0
;MyProject.c,125 :: 		}
L_end_pwm1:
	RETURN
; end of _pwm1

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,129 :: 		void interrupt (void)  {                       //функция обработки всех прерываний
;MyProject.c,131 :: 		if (INTCON.T0IF) {                          //если прерывание от TMR0..
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt29
;MyProject.c,132 :: 		INTCON.T0IF = 0;                        //...сбрасываем флаг
	BCF        INTCON+0, 2
;MyProject.c,134 :: 		}
L_interrupt29:
;MyProject.c,135 :: 		if( PIR1.TMR1IF ){                         //прерывания два раза в секунду
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt30
;MyProject.c,136 :: 		PIR1.TMR1IF=0;
	BCF        PIR1+0, 0
;MyProject.c,141 :: 		switch (a){
	GOTO       L_interrupt31
;MyProject.c,143 :: 		case 0 :    t= Ow_Reset(&GPIO, 5);
L_interrupt33:
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
	MOVF       R0+0, 0
	MOVWF      _t+0
;MyProject.c,144 :: 		Ow_Reset(&GPIO, 5);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;MyProject.c,145 :: 		Ow_write(&GPIO, 5,0xCC);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;MyProject.c,146 :: 		Ow_write(&GPIO, 5,0x44);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;MyProject.c,147 :: 		a=1;
	MOVLW      1
	MOVWF      _a+0
;MyProject.c,149 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,150 :: 		case 1 :    Ow_Reset(&GPIO, 5);
L_interrupt34:
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;MyProject.c,151 :: 		Ow_write(&GPIO, 5,0xCC);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;MyProject.c,152 :: 		Ow_write(&GPIO, 5,0xBE);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;MyProject.c,153 :: 		a=2;
	MOVLW      2
	MOVWF      _a+0
;MyProject.c,154 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,155 :: 		case 2 :   a=3;
L_interrupt35:
	MOVLW      3
	MOVWF      _a+0
;MyProject.c,156 :: 		BUZZER=0;                       //выключаем зуммер
	BCF        GPIO+0, 4
;MyProject.c,157 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,158 :: 		case 3 :   a=4;
L_interrupt36:
	MOVLW      4
	MOVWF      _a+0
;MyProject.c,159 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,160 :: 		case 4 :   a=5;
L_interrupt37:
	MOVLW      5
	MOVWF      _a+0
;MyProject.c,161 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,162 :: 		case 5 :   a=6;
L_interrupt38:
	MOVLW      6
	MOVWF      _a+0
;MyProject.c,163 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,164 :: 		case 6 :   a=7;
L_interrupt39:
	MOVLW      7
	MOVWF      _a+0
;MyProject.c,165 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,167 :: 		case 7 :    n=Ow_Read(&GPIO,5);                               //читаем температуру
L_interrupt40:
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _n+0
;MyProject.c,168 :: 		temperature=Ow_Read(&GPIO,5);
	MOVLW      GPIO+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      5
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temperature+0
;MyProject.c,169 :: 		n >>=4;
	MOVF       _n+0, 0
	MOVWF      R2+0
	RRF        R2+0, 1
	BCF        R2+0, 7
	RRF        R2+0, 1
	BCF        R2+0, 7
	RRF        R2+0, 1
	BCF        R2+0, 7
	RRF        R2+0, 1
	BCF        R2+0, 7
	MOVF       R2+0, 0
	MOVWF      _n+0
;MyProject.c,170 :: 		temperature <<= 4;
	MOVF       R0+0, 0
	MOVWF      _temperature+0
	RLF        _temperature+0, 1
	BCF        _temperature+0, 0
	RLF        _temperature+0, 1
	BCF        _temperature+0, 0
	RLF        _temperature+0, 1
	BCF        _temperature+0, 0
	RLF        _temperature+0, 1
	BCF        _temperature+0, 0
;MyProject.c,171 :: 		temperature += n;
	MOVF       R2+0, 0
	ADDWF      _temperature+0, 1
;MyProject.c,172 :: 		a=8;
	MOVLW      8
	MOVWF      _a+0
;MyProject.c,174 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,176 :: 		case 8:     fn_Auto_Cooler();
L_interrupt41:
	CALL       _fn_Auto_Cooler+0
;MyProject.c,178 :: 		a=0;
	CLRF       _a+0
;MyProject.c,179 :: 		break;
	GOTO       L_interrupt32
;MyProject.c,181 :: 		default:     break;
L_interrupt42:
	GOTO       L_interrupt32
;MyProject.c,183 :: 		}                                //end case
L_interrupt31:
	MOVF       _a+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt33
	MOVF       _a+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt34
	MOVF       _a+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt35
	MOVF       _a+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt36
	MOVF       _a+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt37
	MOVF       _a+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt38
	MOVF       _a+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt39
	MOVF       _a+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt40
	MOVF       _a+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt41
	GOTO       L_interrupt42
L_interrupt32:
;MyProject.c,186 :: 		}                                         //end TMR1
L_interrupt30:
;MyProject.c,187 :: 		}                                            //end interrupts
L_end_interrupt:
L__interrupt56:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,191 :: 		void main() {
;MyProject.c,193 :: 		TRISIO = 0b101011;                          // направление работы ножек порта А
	MOVLW      43
	MOVWF      TRISIO+0
;MyProject.c,194 :: 		CMCON = 0x07;                               // отключение компараторов
	MOVLW      7
	MOVWF      CMCON+0
;MyProject.c,195 :: 		GPIO = 0b000000;                            // очищаем порт
	CLRF       GPIO+0
;MyProject.c,196 :: 		OPTION_REG=0b10000000;                      // настройки TMR0
	MOVLW      128
	MOVWF      OPTION_REG+0
;MyProject.c,197 :: 		WPU =0b00000000;                            // подтягивающие R
	CLRF       WPU+0
;MyProject.c,198 :: 		CMCON=0b000000111;                          //отключаем компаратор
	MOVLW      7
	MOVWF      CMCON+0
;MyProject.c,199 :: 		ADCON0=0b00000000;                          //настройка АЦП
	CLRF       ADCON0+0
;MyProject.c,200 :: 		ANSEL=0b00000000;                           //определяем входы как цифровые
	CLRF       ANSEL+0
;MyProject.c,201 :: 		INTCON=0b11000000;                          //настройки прерываний
	MOVLW      192
	MOVWF      INTCON+0
;MyProject.c,202 :: 		PIE1=00000001;                              //  настройки прерываний
	MOVLW      1
	MOVWF      PIE1+0
;MyProject.c,203 :: 		IOCB=00000000;                              //
	CLRF       IOCB+0
;MyProject.c,204 :: 		T1CON =0b00010001;                          //настройки таймера TMR1 FOSC/4
	MOVLW      17
	MOVWF      T1CON+0
;MyProject.c,206 :: 		fn_Init_Const();                         //чтение констант из EEPROM
	CALL       _fn_Init_Const+0
;MyProject.c,207 :: 		OUT_COOLER=1;                            //импульс при включении устройства
	BSF        GPIO+0, 2
;MyProject.c,208 :: 		delay_ms(500);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main43:
	DECFSZ     R13+0, 1
	GOTO       L_main43
	DECFSZ     R12+0, 1
	GOTO       L_main43
	DECFSZ     R11+0, 1
	GOTO       L_main43
	NOP
	NOP
;MyProject.c,210 :: 		while(1){
L_main44:
;MyProject.c,211 :: 		if(t==1) pwm_duty_b=49;              //если датчик не подключен(неисправен,обрыв) ставим максимальное заполнение ШИМ
	MOVF       _t+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main46
	MOVLW      49
	MOVWF      _pwm_duty_b+0
L_main46:
;MyProject.c,212 :: 		OUT_COOLER=pwm1(pwm_duty_b);         //функция программный ШИМ
	MOVF       _pwm_duty_b+0, 0
	MOVWF      FARG_pwm1_n+0
	CALL       _pwm1+0
	BTFSC      R0+0, 0
	GOTO       L__main58
	BCF        GPIO+0, 2
	GOTO       L__main59
L__main58:
	BSF        GPIO+0, 2
L__main59:
;MyProject.c,214 :: 		}                                      //end while
	GOTO       L_main44
;MyProject.c,216 :: 		}                                         //end main
L_end_main:
	GOTO       $+0
; end of _main
