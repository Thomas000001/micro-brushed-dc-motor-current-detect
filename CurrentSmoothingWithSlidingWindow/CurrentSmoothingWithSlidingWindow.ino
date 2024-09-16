#include <Wire.h>
#include <Adafruit_INA219.h>

Adafruit_INA219 ina219;
unsigned long start_time;
unsigned long print_time;
unsigned long time1;
long time = 0;
const int windowSize = 10;  // 滑动窗口大小
float currentWindow[windowSize];  // 存储最近几次电流读数
int windowIndex = 0;  // 当前窗口中的位置
float filteredCurrent_mA = 0;  // 滤波后的电流值

void setup(void) 
{
  Serial.begin(115200);
  pinMode(8, OUTPUT);
  time = 0;
  while (!Serial) {
      delay(1);
  }
    
  Serial.println("Hello!");

  while(! ina219.begin()) {
    Serial.println("Failed to find INA219 chip");
  }
  Serial.println("Succeed to find INA219 chip");

  Serial.println("Measuring voltage and current with INA219 ...");
}

void loop(void) 
{
  float current_mA = 0;

  // 记录开始采样的时间
  start_time = micros();

  current_mA = ina219.getCurrent_mA();
  unsigned long print_time = micros(); // 记录采样完成的时间

  time1 = print_time - time; // 计算此次采样所经过的时间
  Serial.print("T:"); // 时间标识符
  Serial.print(time1); 
  Serial.print(",C:"); // 电流标识符

  // 将新的电流读数添加到窗口中
  currentWindow[windowIndex] = current_mA;
  windowIndex = (windowIndex + 1) % windowSize;  // 更新窗口索引

  // 如果窗口已满，计算平均值
  if (windowIndex == 0) {


    filteredCurrent_mA = calculateAverage(currentWindow, windowSize);
  }

  Serial.print(filteredCurrent_mA); // 输出滤波后的电流值
  Serial.println("");  // 换行

  time = print_time;  // 储存此次采样所经过的总时间
  delay(7);
}

// 计算滑动窗口内的平均值
float calculateAverage(float *array, int size)
{
  float sum = 0.0;
  for (int i = 0; i < size; i++)
  {
    sum += array[i];
  }
  return sum / size;
}
