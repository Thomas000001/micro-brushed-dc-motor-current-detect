/***************************************************************************
  Example sketch for the ICM20948_WE library

  This sketch shows how to setup the magnetometer and how to query magnetometer
  data. The magnetometer is a seperate unit on the module. It has its own I2C 
  address. All read and write accesses are done via a kind of I2C "sub-bus". You
  don't access the magnetometer registers directly. 
   
  Further information can be found on:

  https://wolles-elektronikkiste.de/icm-20948-9-achsensensor-teil-i (German)
  https://wolles-elektronikkiste.de/en/icm-20948-9-axis-sensor-part-i (English)

***************************************************************************/

#include <Wire.h>
#include <ICM20948_WE.h>
#define ICM20948_ADDR 0x68

/* There are several ways to create your ICM20948 object:
 * ICM20948_WE myIMU = ICM20948_WE()              -> uses Wire / I2C Address = 0x68
 * ICM20948_WE myIMU = ICM20948_WE(ICM20948_ADDR) -> uses Wire / ICM20948_ADDR
 * ICM20948_WE myIMU = ICM20948_WE(&wire2)        -> uses the TwoWire object wire2 / ICM20948_ADDR
 * ICM20948_WE myIMU = ICM20948_WE(&wire2, ICM20948_ADDR) -> all together
 * ICM20948_WE myIMU = ICM20948_WE(CS_PIN, spi);  -> uses SPI, spi is just a flag, see SPI example
 * ICM20948_WE myIMU = ICM20948_WE(&SPI, CS_PIN, spi);  -> uses SPI / passes the SPI object, spi is just a flag, see SPI example
 */
ICM20948_WE myIMU = ICM20948_WE(ICM20948_ADDR);

unsigned long start_time;
unsigned long print_time;
unsigned long time;

void setup() {
  Wire.begin();
  Serial.begin(115200);
  while (!Serial) {}

  while (!myIMU.init()) {
    Serial.println("ICM20948 does not respond");
  }
  Serial.println("ICM20948 is connected");


  while (!myIMU.initMagnetometer()) {
    Serial.println("Magnetometer does not respond");
  }
  Serial.println("Magnetometer is connected");

  /* You can set the following modes for the magnetometer:
   * AK09916_PWR_DOWN          Power down to save energy
   * AK09916_TRIGGER_MODE      Measurements on request, a measurement is triggered by 
   *                           calling setMagOpMode(AK09916_TRIGGER_MODE)
   * AK09916_CONT_MODE_10HZ    Continuous measurements, 10 Hz rate
   * AK09916_CONT_MODE_20HZ    Continuous measurements, 20 Hz rate
   * AK09916_CONT_MODE_50HZ    Continuous measurements, 50 Hz rate
   * AK09916_CONT_MODE_100HZ   Continuous measurements, 100 Hz rate (default)
   */
  myIMU.setMagOpMode(AK09916_CONT_MODE_20HZ);
}

void loop() {
  myIMU.readSensor();
  xyzFloat magValue = myIMU.getMagValues(); // returns magnetic flux density [µT]

  // xyzFloat magValue[100];
  // int k;

  // start_time = micros();
  // for(k=1;k<=100;k++)
  // {
  //   magValue[k] = myIMU.getMagValues();
  // }
  // print_time = micros();
  // time = print_time - start_time;
  // Serial.println("采样100次的时间:");
  // Serial.print(time); Serial.print("us");
  // Serial.println(" ");
  Serial.print(magValue.y);
  Serial.println(" ");


  // Serial.println("Magnetometer Data in µTesla: ");
  // Serial.print(magValue.x);
  // Serial.print("   ");
  // Serial.print(magValue.y);
  // Serial.print("   ");
  // Serial.println(magValue.z);

  delay(20);
}
