#include <LiquidCrystal.h>

int fpga0 = A0;
int fpga1 = A1;
int fpga2 = A2;
int rdy = A3;

LiquidCrystal lcd(12, 11, 5, 4, 3, 2); //LCD Pins

void setup() {
  // put your setup code here, to run once:
  pinMode(fpga0, INPUT);
  pinMode(fpga1, INPUT);
  pinMode(fpga2, INPUT);
  pinMode(rdy, INPUT);
  lcd.begin(16,2);
  Serial.begin(9600);
}

int readInThreshold = 500;
int bit0, bit1, bit2;
int digit;
int counter = 0;
int rdyIsHigh = 0;

void loop() {
  // put your main code here, to run repeatedly:
  if(analogRead(rdy) < readInThreshold)
  {
    rdyIsHigh=0;
  }
  if(analogRead(rdy) >= readInThreshold)
  {
    rdyIsHigh++;
    if(analogRead(fpga0) >= readInThreshold)
    {
      bit0 = 1;
    }
    if(analogRead(fpga0) < readInThreshold)
    {
      bit0 = 0;
    }
    if(analogRead(fpga1) >= readInThreshold)
    {
      bit1 = 1;
    }
    if(analogRead(fpga1) < readInThreshold)
    {
      bit1 = 0;
    }
    if(analogRead(fpga2) >= readInThreshold)
    {
      bit2 = 1;
    }
    if(analogRead(fpga2) < readInThreshold)
    {
      bit2 = 0;
    }
  }

  digit = ((4*bit2) + (2*bit1) + bit0);
  if(digit == 0)
  {
    lcd.clear();
    counter = 0;
  }
  if(digit >= 1 && digit <=6 && analogRead(rdy) >= readInThreshold && rdyIsHigh == 1)
  {
    lcd.setCursor(counter, 0);
    lcd.print(digit);
    counter++;
  }
  

//  lcd.print(x);
//  delay(3000);
//  lcd.setCursor(2,1);
//  lcd.print("Hello World");
//  delay(3000);
//  lcd.clear();
//  delay(3000);

}
