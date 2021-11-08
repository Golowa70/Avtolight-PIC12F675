#line 1 "C:/Users/Public/Documents/Mikroelektronika/mikroC PRO for PIC/Projects/cooler_12f675/MyProject.c"




unsigned short pwm_duty_b =0 ;
unsigned short a=0;
unsigned short t;

unsigned short n ;
unsigned short temperature = 0;
unsigned short set_Pwm=0;
volatile unsigned short flag_Status_Cooler;


unsigned short Const_Temp1 ;
unsigned short Const_Temp2 ;
unsigned short Const_Temp3 ;
unsigned short Const_Temp4 ;

 unsigned short Const_Pwm1 ;
 unsigned short Const_Pwm2 ;
 unsigned short Const_Pwm3 ;



 void fn_Init_Const (void){
 Const_Temp1 = EEPROM_Read (0x0);
 Const_Temp2 = EEPROM_Read (0x1);
 Const_Temp3 = EEPROM_Read (0x2);
 Const_Temp4 = EEPROM_Read (0x3);
 Const_Pwm1 = EEPROM_Read (0x4);
 Const_Pwm2 = EEPROM_Read (0x5);
 Const_Pwm3 = EEPROM_Read (0x6);
 }


unsigned short pwm1 (unsigned short n );


 void fn_Auto_Cooler(void){


 if(temperature >= Const_Temp1) {


 if((temperature >= Const_Temp1) && (temperature < Const_Temp2) ) {
 if(set_Pwm == Const_Pwm2){
 if(temperature < (Const_Temp2-2)) set_Pwm=Const_Pwm1;
 }
 else
 set_Pwm=Const_Pwm1;


 }
 else {
 if((temperature >= Const_Temp2) && (temperature < Const_Temp3) ) {
 if(set_Pwm == Const_Pwm3){
 if(temperature < (Const_Temp3-2)) set_Pwm=Const_Pwm2;
 }
 else
 set_Pwm=Const_Pwm2;

 }
 else {
 if(temperature >= Const_Temp3) {
 set_Pwm=Const_Pwm3;
 if(temperature > Const_Temp4) GPIO.B4 =1;

 }
 }
 }


 if(flag_Status_Cooler == 0){
 pwm_duty_b=45;
 flag_Status_Cooler=1;
 }
 else {
 pwm_duty_b=set_Pwm;
 }



 }
 else {
 if(temperature <(Const_Temp1-2)) {
 pwm_duty_b=0;
 flag_Status_Cooler=0;
 }
 }



 }



 unsigned short pwm1 (unsigned short n ){

 unsigned short k;
 unsigned short volatile pwmcycle;


 switch(n) {
 case 0:
 k = 0;
 break;
 case 50 :
 k = 1;
 break;
 default:


 if (pwmcycle <= n)
 k = 1;
 else
 k = 0;
 }

 if (++pwmcycle == 50 ) {
 pwmcycle = 0;
 }

 return k ;
}



 void interrupt (void) {

 if (INTCON.T0IF) {
 INTCON.T0IF = 0;

 }
 if( PIR1.TMR1IF ){
 PIR1.TMR1IF=0;




 switch (a){

 case 0 : t= Ow_Reset(&GPIO, 5);
 Ow_Reset(&GPIO, 5);
 Ow_write(&GPIO, 5,0xCC);
 Ow_write(&GPIO, 5,0x44);
 a=1;

 break;
 case 1 : Ow_Reset(&GPIO, 5);
 Ow_write(&GPIO, 5,0xCC);
 Ow_write(&GPIO, 5,0xBE);
 a=2;
 break;
 case 2 : a=3;
  GPIO.B4 =0;
 break;
 case 3 : a=4;
 break;
 case 4 : a=5;
 break;
 case 5 : a=6;
 break;
 case 6 : a=7;
 break;

 case 7 : n=Ow_Read(&GPIO,5);
 temperature=Ow_Read(&GPIO,5);
 n >>=4;
 temperature <<= 4;
 temperature += n;
 a=8;

 break;

 case 8: fn_Auto_Cooler();

 a=0;
 break;

 default: break;

 }


 }
 }



void main() {

TRISIO = 0b101011;
CMCON = 0x07;
GPIO = 0b000000;
OPTION_REG=0b10000000;
WPU =0b00000000;
CMCON=0b000000111;
ADCON0=0b00000000;
ANSEL=0b00000000;
INTCON=0b11000000;
PIE1=00000001;
IOCB=00000000;
T1CON =0b00010001;

 fn_Init_Const();
  GPIO.B2 =1;
 delay_ms(500);

 while(1){
 if(t==1) pwm_duty_b=49;
  GPIO.B2 =pwm1(pwm_duty_b);

 }

}
