//Weather UDP
/*
This code is for a WiFi-connected Particle Photon wired up to a 3.5 digit 7
segment common anode display. When it receives a UDP packet, it will show the
temperature on the display. It can update as fast as you want it to.

I am using this with a scheduled Powershell task running on my PC. That script
is getting the weather from :
      openweathermap.org
and sending the temperature to the Photon.
The powershell script is also displaying this temperature on my computer as
balloon notifications.
*/


//Temperature UDP Initialization
/*
This is where I will send the temperature as a uint_8
I use that number directly as a temperature. Right now,
I only display 2 digits, but it will be a while until it
gets into the 100s... I hope...
And I don't handle negatives yet... But it's summer, how
cold can it possibly get...
*/
UDP Udp;
unsigned int tempPort = 8888;
int digit1s = 0;
int digit10s = 0;
int digit1sOld = 0;// For some reason, digit1s and 10s were resetting every time loop() was executed.
int digit10sOld = 0;//When a UDP packet was received, it held for a second, but quickly reseted the next step
//I added these digitOlds to ensure that they were defined every execution
//While I have them there, I should look into storing these, so when it starts up, it holds the last value

/* TODO
 In powershell, read  FORECASTED (24 hours?) weather codes from api :
    https://openweathermap.org/weather-conditions
Convert that into a a case:
1-clear
2-rain
3-snow
4-cloud
I can't use the weather code as it is because they are in the 200-800 range
I suppose this would be a time where having the particle read directly from
the cloud works better, but that makes means no more powershell :(
Depending on the triggered case, light up a different LED/LCD pins
///////////////////////////////////////////
UDP Udp2;
unsigned int weatherPort= 8889;
int weather = 0;
int weatherOld = 0;
//^^This logic works; the Particle Photon can correctly read from 2 ports at once


// LED pins and the digit-delay length
#define LED1 D7
int segmentPins[7]  = {D0,D1,D2,D3,D4,D6,D5};
int anodeOnes       = A1;
int anodeTens       = A0;
int delayLength     = 5;
int i;


// https://www.scribd.com/document/309741804/Ard1-Using-7-Segment-and-PWM
// ^I copy-pasted this matrix and how to use it from this website^
int seven_seg_digits[10][7] = { { 1,1,1,1,1,1,0 },  // = 0 seven_seg_digits is a 2 dimensional array
                            { 0,1,1,0,0,0,0 },  // = 1 that contains information about the led
                            { 1,1,0,1,1,0,1 },  // = 2 combination to show a particular digit
                            { 1,1,1,1,0,0,1 },  // = 3 [10][7] means this array has 10 rows, and
                            { 0,1,1,0,0,1,1 },  // = 4 7 columns.
                            { 1,0,1,1,0,1,1 },  // = 5
                            { 1,0,1,1,1,1,1 },  // = 6
                            { 1,1,1,0,0,0,0 },  // = 7
                            { 1,1,1,1,1,1,1 },  // = 8
                            { 1,1,1,0,0,1,1 }   // = 9
                            };



void setup() {
    Particle.variable("Temperature", i);
    Serial.begin(9600);
    Udp.begin(tempPort);
    /* Hiding this second port stuff for now
    UdpWeather.begin(weatherPort);
    */
    pinMode(LED1,OUTPUT);
    pinMode(anodeTens,OUTPUT);
    pinMode(anodeOnes,OUTPUT);
    for (unsigned int  pin = 0; pin < 7; ++pin)
        { // Set all the cathodes to LOW voltage
            pinMode(segmentPins[pin],OUTPUT);
            digitalWrite(segmentPins[pin],LOW);
          }
    for (unsigned int i = 0; i < 3; ++i)
    {//Flash the LEDS a few times to verify that the LCD is working
      digitalWrite(LED1,HIGH);
      digitalWrite(anodeTens,HIGH);
      digitalWrite(anodeOnes,HIGH);
      delay(250);
      digitalWrite(LED1,LOW);
      digitalWrite(anodeTens,LOW);
      digitalWrite(anodeOnes,LOW);
      delay(250);
    }
}


void loop()
{
  /*
  unsigned int start = millis(); // I was using this to get the execution time of each step.
  The execution time ended up being under 1ms, other than my 2 delayLength pauses.
  I used that to determine how long to make my delays
  */
    if (Udp.parsePacket() > 0)
    {// UDP (temp) received
      //Print the value
        Serial.println("TEMP PACKET RECEIVED");
        i = Udp.read();
        Serial.println((i));

        // Convert the uint_8 value
        digit10s = (int) min(max(i/10,0),9);
        digit1s  = (int) min(max(round(i-digit10s*10),0),9);
        Serial.println(digit10s);
        Serial.println(digit1s);
    } else { // UDP not received, so hold the last value
        digit1s = digit1sOld;
        digit10s = digit10sOld;
    }
/* Hiding the second port stuff...
    if (UdpWeather.parsePacket() > 0)    {
        Serial.println("WEATHER PACKET RECEIVED");
        int weather = UdpWeather.read();
        Serial.println((i2));
    } else {
        weather=weatherOld;
    }
*/
    //ONES
    //Write temperature to the 1s digit
    digitalWrite(anodeOnes,HIGH);   //Enable the 1s anode for now
    digitalWrite(anodeTens,LOW);    //Disable the 10s anode for now
    for (unsigned int  pin = 0; pin < 7; ++pin)
        { // I copied this section from the same place as that Pin Matrix
            digitalWrite(segmentPins[pin], !seven_seg_digits[digit1s][pin]);
        }
    delay(delayLength); //Without these delays, the 10s digit remains on for
                        //much longer than the 1s, making the ones very-not-bright

    //TENDS
    //Write temperature to the 10s digit
    digitalWrite(anodeTens,HIGH);   //Enable the 10s anode for now
    digitalWrite(anodeOnes,LOW);    //Disable the 1s anode for now
    for (unsigned int  pin = 0; pin < 7; ++pin)
        { // I copied this section from the same place as that Pin Matrix
            digitalWrite(segmentPins[pin], !seven_seg_digits[digit10s][pin]);
          }
    delay(delayLength);

    // This is to ensure that the digit1/0s don't get overwritten each time
    digit10sOld=digit10s;
    digit1sOld=digit1s;
    // weatherOld=weather;

    /* This was to print the execution time over serial. The 1000ms delay is so I
    don't spam it.
    unsigned int stop=millis();
    Serial.println(stop-start);
    delay(1000);
    */
}
