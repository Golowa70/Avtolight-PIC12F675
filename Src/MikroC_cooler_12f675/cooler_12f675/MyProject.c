/*блок дефайнов***************************************************************************************************/
#define OUT_COOLER   GPIO.B2
#define BUZZER       GPIO.B4
/*объявляем прерменные********************************************************************************************/
unsigned short pwm_duty_b =0 ;               //переменные, для буферизации значений скважности ШИМ
unsigned short a=0;                          //служебная переменная (switch)
unsigned short t;                            //флаг присутствия датчика ds18b20

unsigned short n ;                           //служебная переменная(вычисление температуры)
unsigned short temperature = 0;              //значение температуры
unsigned short set_Pwm=0;                    //переменные, для изменения скважности ШИМ в программе
volatile unsigned short flag_Status_Cooler;           //флаг состояния кулера(вкл/выкл)


unsigned short Const_Temp1 ;                 //   первый уровень температуры
unsigned short Const_Temp2 ;                 //   второй уровень температуры
unsigned short Const_Temp3 ;                 //   третий уровень температуры
unsigned short Const_Temp4 ;                 //   порог включения звуковой сигнализации

 unsigned short Const_Pwm1 ;                 //   первый уровень ШИМ (скважность)
 unsigned short Const_Pwm2 ;                 //    второй уровень ШИМ
 unsigned short Const_Pwm3 ;                 //    третий уровень ШИМ
/*****************************************************************************************************************/

  //------------------------------------------------------------------------------------
   void fn_Init_Const (void){
   Const_Temp1 = EEPROM_Read (0x0);                //  30
   Const_Temp2 = EEPROM_Read (0x1);                //  45
   Const_Temp3 = EEPROM_Read (0x2);                //  60
   Const_Temp4 = EEPROM_Read (0x3);                //поорог включения зуммера 75
   Const_Pwm1  = EEPROM_Read (0x4);                //   10
   Const_Pwm2  = EEPROM_Read (0x5);                //   25
   Const_Pwm3  = EEPROM_Read (0x6);                //   48
  }

//-------------------------------------------------------------------------------------
unsigned short pwm1 (unsigned short n );
//------------------------------------------------------------------------------------
  
   void fn_Auto_Cooler(void){                                             //фукция авторегулировки оборотов
                                                                         

   if(temperature >= Const_Temp1) {                                     //если температура больше первого уровня
   
   
     if((temperature >= Const_Temp1) && (temperature < Const_Temp2) )  {     //если в пределах между первым и вторым уровнями...
        if(set_Pwm == Const_Pwm2){                                          //если сейчас на втором уровне ШИМ...
           if(temperature < (Const_Temp2-2)) set_Pwm=Const_Pwm1;            //гистерезис
          }
           else
            set_Pwm=Const_Pwm1;                                              //иначе выставляем первый уровень ШИМ

     
     }
     else   {
       if((temperature >= Const_Temp2) && (temperature < Const_Temp3) )  {    //если в пределах между вторым и третим уровнями...
          if(set_Pwm == Const_Pwm3){
            if(temperature < (Const_Temp3-2)) set_Pwm=Const_Pwm2;
          }
            else
              set_Pwm=Const_Pwm2;

       }
       else {
          if(temperature >= Const_Temp3) {
           set_Pwm=Const_Pwm3;
             if(temperature > Const_Temp4)BUZZER=1;                         //если температура больше допустимой (Temp4) включаем зуммер.
       
           }
        }
     }
     
     
     if(flag_Status_Cooler == 0){                              //если кулер не запущен...
           pwm_duty_b=45;                                      //делаем старт с максимальной скважностью ШИМ...
           flag_Status_Cooler=1;                               //выставляем флаг,что кулер запущен
         }
       else {
          pwm_duty_b=set_Pwm;                                  //иначе заполнение ШИМ ставим в соответствии с значением температуры
         }
     
     
     
    }
    else {
      if(temperature <(Const_Temp1-2)) {                        //если температура опустилась ниже первого уровня...
        pwm_duty_b=0;                                           //выключаем кулер
        flag_Status_Cooler=0;                                   // сбрасываем флаг
        }
      }
      
 //***************************

  }

  //*************************************************************************************************

    unsigned short pwm1 (unsigned short n ){       //функция программный ШИМ
    
        unsigned short  k;
        unsigned short volatile pwmcycle;


 switch(n) {                                     //переключатель определяет крайние положения ШИМ1
            case 0:
                k = 0;
                break;
            case 50 :
                k = 1;
                break;
            default:


            if (pwmcycle <= n)                    // и устанавливает длинну импульса ШИМ1
                k = 1;
             else
                k = 0;
   }

           if (++pwmcycle == 50 ) {              //  если отсчитали 50 циклов
             pwmcycle = 0;                       //     обнуляем счетчик циклов
           }

           return k ;
}

/****************************************************************************************************************/

 void interrupt (void)  {                       //функция обработки всех прерываний

    if (INTCON.T0IF) {                          //если прерывание от TMR0..
        INTCON.T0IF = 0;                        //...сбрасываем флаг

        }
    if( PIR1.TMR1IF ){                         //прерывания два раза в секунду
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
                         BUZZER=0;                       //выключаем зуммер
                          break;
               case 3 :   a=4;
                          break;
               case 4 :   a=5;
                          break;
               case 5 :   a=6;
                          break;
               case 6 :   a=7;
                          break;
                          
               case 7 :    n=Ow_Read(&GPIO,5);                               //читаем температуру
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

TRISIO = 0b101011;                          // направление работы ножек порта А
CMCON = 0x07;                               // отключение компараторов
GPIO = 0b000000;                            // очищаем порт
OPTION_REG=0b10000000;                      // настройки TMR0
WPU =0b00000000;                            // подтягивающие R
CMCON=0b000000111;                          //отключаем компаратор
ADCON0=0b00000000;                          //настройка АЦП
ANSEL=0b00000000;                           //определяем входы как цифровые
INTCON=0b11000000;                          //настройки прерываний
PIE1=00000001;                              //  настройки прерываний
IOCB=00000000;                              //
T1CON =0b00010001;                          //настройки таймера TMR1 FOSC/4

   fn_Init_Const();                         //чтение констант из EEPROM
   OUT_COOLER=1;                            //импульс при включении устройства
   delay_ms(500);
   
   while(1){
      if(t==1) pwm_duty_b=49;              //если датчик не подключен(неисправен,обрыв) ставим максимальное заполнение ШИМ
      OUT_COOLER=pwm1(pwm_duty_b);         //функция программный ШИМ

   }                                      //end while

}                                         //end main