#include <SoftwareSerial.h>    
// PINS
#define in1 8
#define in2 9
#define in3 10
#define in4 11
#define in5 12
#define rxofnano 2
#define txofnano 3
#define add1 0

SoftwareSerial gsm(rxofnano, txofnano); /*tx of gsm to rxofnano(2) and rx of sim 800L to txofnano(3)*/
int fg = 0;
bool prev[5] = {0};   //to remember previous status         // VARIABLES
bool curr[5] = {0};   //to remember present status
char msg[7];
bool a,b; // for debounce

void setup() 
{ 
  int val;
  Serial.begin(9600); //intialising Arduino
  //intialising input
  pinMode(in1, INPUT_PULLUP);                               // SETUP
  pinMode(in2, INPUT_PULLUP);
  pinMode(in3, INPUT_PULLUP);
  pinMode(in4, INPUT_PULLUP);
  pinMode(in5, INPUT_PULLUP);  
  gsm.begin(9600);    //intialising gsm module
  for (int i = 0; i < 3; i++)
  {
    digitalWrite(13, HIGH);
    delay(150);
    digitalWrite(13, LOW);
    delay(150);
  }
  msg[5] = (char)26;
  msg[6] = '\0';
  gsm.print("AT+CMGF=1\r");                   //Set the module to SMS mode
  delay(50);
  DELAY();
}


void updateserial()   //for debugging and clearing serial buffer
{ 
  Serial.println(gsm.available());
  while (Serial.available())
  {
    gsm.write(Serial.read());                               //UPDATESERIAL
  }
  while (gsm.available())
  {
    Serial.write(gsm.read());
  }
}

void btos()
{
  for (int i = 0; i < 5; ++i)                               //BTOS
    msg[i] = prev[i] + 48;
}

void DELAY()
{
  Serial.println("waiting ...");                            //DELAY
  bool X = 1;
  int count=0;
  while (X&&count<90)
  { delay(100);
    while (gsm.available())
    { if (gsm.read() == 'O')
      {
        if (gsm.read() == 'K')
          { X = 0;
            Serial.println("Over");  }
      }
    }
    count++;
  }
  if(count==90)
      {Serial.println("Terminated");fg=1;}  /*if it got terminated it didnt send any message i.e didnt recieved ok so we need to make fg=1  as we need send latest message*/
}

void message()
{
  
  gsm.print("AT+CMGS=\"+91xxxxxxxxxx\"\r");   //phone number with country code
  delay(50);
  gsm.print(msg);                             //message to send
  delay(100);
  DELAY();
  Serial.print(msg);
  Serial.println("\tSent");
  updateserial();
}

void loop() {
  for (int i = 0; i < 5; ++i)
  { 
    a = digitalRead(8+i);       // debounce. quick changes (<100ms) not considered
    delay(100);
    b = digitalRead(8+i);
    if(a==b)
    curr[i] = b;
    
    if (curr[i] != prev[i])
    {
      prev[i] = curr[i];
      fg = 1;
    }
  }
  if (fg == 1)
  {
    btos();
    delay(200);
    if(gsm.available()!=0)    //if buffer is not empty we will clear it and send message 
    { 
      updateserial();
      fg = 0;
      message();
     Serial.println("through if"); //we will not see terminated state
    }
    else                      //even if it changes in between as we need send latest status it wont effect
    {
    fg = 0;
    message();
    Serial.println("through else");//means no buffer intially there may be a case of terminated state
    }
  }
  updateserial();
}
