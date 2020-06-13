#include <LiquidCrystal.h>

int fpga0 = A1;
int fpga1 = A2;
int fpga2 = A3;
int rdy = A4;

LiquidCrystal lcd(7, 6, 5, 4, 3, 2); //LCD Pins

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
    bit0 = (analogRead(fpga0) >= readInThreshold);
    bit1 = (analogRead(fpga1) >= readInThreshold);
    bit2 = (analogRead(fpga2) >= readInThreshold);

  }

  digit = ((4*bit2) + (2*bit1) + bit0);
  if(digit == 0 && rdyIsHigh == 1)
  {
    lcd.clear();
    counter = 0;
  }
  if(digit >= 1 && digit <=6 && rdyIsHigh == 1)
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
