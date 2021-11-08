/*���� ��������***************************************************************************************************/
#define OUT_COOLER   GPIO.B2
#define BUZZER       GPIO.B4
/*��������� ����������********************************************************************************************/
unsigned short pwm_duty_b =0 ;               //����������, ��� ����������� �������� ���������� ���
unsigned short a=0;                          //��������� ���������� (switch)
unsigned short t;                            //���� ����������� ������� ds18b20

unsigned short n ;                           //��������� ����������(���������� �����������)
unsigned short temperature = 0;              //�������� �����������
unsigned short set_Pwm=0;                    //����������, ��� ��������� ���������� ��� � ���������
volatile unsigned short flag_Status_Cooler;           //���� ��������� ������(���/����)


unsigned short Const_Temp1 ;                 //   ������ ������� �����������
unsigned short Const_Temp2 ;                 //   ������ ������� �����������
unsigned short Const_Temp3 ;                 //   ������ ������� �����������
unsigned short Const_Temp4 ;                 //   ����� ��������� �������� ������������

 unsigned short Const_Pwm1 ;                 //   ������ ������� ��� (����������)
 unsigned short Const_Pwm2 ;                 //    ������ ������� ���
 unsigned short Const_Pwm3 ;                 //    ������ ������� ���
/*****************************************************************************************************************/

  //------------------------------------------------------------------------------------
   void fn_Init_Const (void){
   Const_Temp1 = EEPROM_Read (0x0);                //  30
   Const_Temp2 = EEPROM_Read (0x1);                //  45
   Const_Temp3 = EEPROM_Read (0x2);                //  60
   Const_Temp4 = EEPROM_Read (0x3);                //������ ��������� ������� 75
   Const_Pwm1  = EEPROM_Read (0x4);                //   10
   Const_Pwm2  = EEPROM_Read (0x5);                //   25
   Const_Pwm3  = EEPROM_Read (0x6);                //   48
  }

//-------------------------------------------------------------------------------------
unsigned short pwm1 (unsigned short n );
//------------------------------------------------------------------------------------
  
   void fn_Auto_Cooler(void){                                             //������ ��������������� ��������
                                                                         

   if(temperature >= Const_Temp1) {                                     //���� ����������� ������ ������� ������
   
   
     if((temperature >= Const_Temp1) && (temperature < Const_Temp2) )  {     //���� � �������� ����� ������ � ������ ��������...
        if(set_Pwm == Const_Pwm2){                                          //���� ������ �� ������ ������ ���...
           if(temperature < (Const_Temp2-2)) set_Pwm=Const_Pwm1;            //����������
          }
           else
            set_Pwm=Const_Pwm1;                                              //����� ���������� ������ ������� ���

     
     }
     else   {
       if((temperature >= Const_Temp2) && (temperature < Const_Temp3) )  {    //���� � �������� ����� ������ � ������ ��������...
          if(set_Pwm == Const_Pwm3){
            if(temperature < (Const_Temp3-2)) set_Pwm=Const_Pwm2;
          }
            else
              set_Pwm=Const_Pwm2;

       }
       else {
          if(temperature >= Const_Temp3) {
           set_Pwm=Const_Pwm3;
             if(temperature > Const_Temp4)BUZZER=1;                         //���� ����������� ������ ���������� (Temp4) �������� ������.
       
           }
        }
     }
     
     
     if(flag_Status_Cooler == 0){                              //���� ����� �� �������...
           pwm_duty_b=45;                                      //������ ����� � ������������ ����������� ���...
           flag_Status_Cooler=1;                               //���������� ����,��� ����� �������
         }
       else {
          pwm_duty_b=set_Pwm;                                  //����� ���������� ��� ������ � ������������ � ��������� �����������
         }
     
     
     
    }
    else {
      if(temperature <(Const_Temp1-2)) {                        //���� ����������� ���������� ���� ������� ������...
        pwm_duty_b=0;                                           //��������� �����
        flag_Status_Cooler=0;                                   // ���������� ����
        }
      }
      
 //***************************

  }

  //*************************************************************************************************

    unsigned short pwm1 (unsigned short n ){       //������� ����������� ���
    
        unsigned short  k;
        unsigned short volatile pwmcycle;


 switch(n) {                                     //������������� ���������� ������� ��������� ���1
            case 0:
                k = 0;
                break;
            case 50 :
                k = 1;
                break;
            default:


            if (pwmcycle <= n)                    // � ������������� ������ �������� ���1
                k = 1;
             else
                k = 0;
   }

           if (++pwmcycle == 50 ) {              //  ���� ��������� 50 ������
             pwmcycle = 0;                       //     �������� ������� ������
           }

           return k ;
}

/****************************************************************************************************************/

 void interrupt (void)  {                       //������� ��������� ���� ����������

    if (INTCON.T0IF) {                          //���� ���������� �� TMR0..
        INTCON.T0IF = 0;                        //...���������� ����

        }
    if( PIR1.TMR1IF ){                         //���������� ��� ���� � �������
        PIR1.TMR1IF=0;




      switch (a){
                           
              case 0 :    t= Ow_Reset(&GPIO, 5);
                          Ow_Reset(&GPIO, 5);
                          Ow_write(&GPIO, 5,0xCC);
                          Ow_write(&GPIO, 5,0x44);
                          a=1;

                          break;
              case 1 :    Ow_Reset(&GPIO, 5);
                          Ow_write(&GPIO, 5,0xCC);
                          Ow_write(&GPIO, 5,0xBE);
                          a=2;
                          break;
              case 2 :   a=3;
                         BUZZER=0;                       //��������� ������
                          break;
               case 3 :   a=4;
                          break;
               case 4 :   a=5;
                          break;
               case 5 :   a=6;
                          break;
               case 6 :   a=7;
                          break;
                          
               case 7 :    n=Ow_Read(&GPIO,5);                               //������ �����������
                          temperature=Ow_Read(&GPIO,5);
                          n >>=4;
                          temperature <<= 4;
                          temperature += n;
                          a=8;

                          break;

               case 8:     fn_Auto_Cooler();
                            //OUT_COOLER=1-OUT_COOLER;
                          a=0;
                          break;
                          
              default:     break;

             }                                //end case


    }                                         //end TMR1
 }                                            //end interrupts
 
 /**********************************************************************************/

void main() {

TRISIO = 0b101011;                          // ����������� ������ ����� ����� �
CMCON = 0x07;                               // ���������� ������������
GPIO = 0b000000;                            // ������� ����
OPTION_REG=0b10000000;                      // ��������� TMR0
WPU =0b00000000;                            // ������������� R
CMCON=0b000000111;                          //��������� ����������
ADCON0=0b00000000;                          //��������� ���
ANSEL=0b00000000;                           //���������� ����� ��� ��������
INTCON=0b11000000;                          //��������� ����������
PIE1=00000001;                              //  ��������� ����������
IOCB=00000000;                              //
T1CON =0b00010001;                          //��������� ������� TMR1 FOSC/4

   fn_Init_Const();                         //������ �������� �� EEPROM
   OUT_COOLER=1;                            //������� ��� ��������� ����������
   delay_ms(500);
   
   while(1){
      if(t==1) pwm_duty_b=49;              //���� ������ �� ���������(����������,�����) ������ ������������ ���������� ���
      OUT_COOLER=pwm1(pwm_duty_b);         //������� ����������� ���

   }                                      //end while

}                                         //end main