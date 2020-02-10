#include <stdarg.h>
#include <stdio.h>
#include <Servo.h>

#include "Arduino.h"

#include "./modeldescription.h"
#include "./data/sources/fmu.h"
#include "./data/sources/fmu.c"
#include "./data/sources/skeleton.c"
#include "./data/sources/misraC/line_following_robot_4S.c"

#define THRESHOLD 150
#define FS 0.4
#define HR 0.3
#define MR 0.2
#define LR 0

Servo servoL;
Servo servoR;
int vL = 1500;
int vR = 1500;

// Callback function for debug
void fmuLoggerCache(void *componentEnvironment, fmi2String instanceName,
    fmi2Status status, fmi2String category, fmi2String format, ...) {
	return;
}
// Global variable for the FMI component instance 
fmi2Component instance = NULL;
ModelInstance* comp;

void setup() {
	Serial.begin(9600);
  
	// Set the servo pins
	servoL.attach(13);
	servoR.attach(12);
  
	fmi2CallbackFunctions callback = { &fmuLoggerCache, NULL, NULL, NULL, NULL };
  
	Serial.println("Instantiating: ");
	instance = fmi2Instantiate("this system", fmi2CoSimulation, FMI_GUID, "", &callback, fmi2True, fmi2True);
	 
	comp = (ModelInstance*)instance;
	 
	comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = 0;
	comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = 0;
	comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = 0;
	comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = 0;
	comp->fmiBuffer.realBuffer[FMI_SERVOLEFTOUT] = 0;
	comp->fmiBuffer.realBuffer[FMI_SERVORIGHTOUT] = 0;
	comp->fmiBuffer.realBuffer[FMI_FORWARDSPEED] = FS;
	comp->fmiBuffer.realBuffer[FMI_HIGHROTATE] = HR;
	comp->fmiBuffer.realBuffer[FMI_MEDIUMROTATE] = MR;
	comp->fmiBuffer.realBuffer[FMI_LOWROTATE] = LR;
	  
	Serial.println("Instantiate called. Result:");
	Serial.println(instance == NULL);
	Serial.println("Setup done");
}

// Variables that are used in the loop() function
double now = 0;
double step = 0.00001;

// After creating a setup() function, which initializes and sets the initial
// values, the loop() function does precisely what its name suggests, and loops
// consecutively, allowing the LFRController to control the robot.
void loop() {

	if(instance == NULL)
		return;
  
	DDRD |= B11110000;                         // Set direction of Arduino pins D4-D7 as OUTPUT
	PORTD |= B11110000;                        // Set level of Arduino pins D4-D7 to HIGH
	delayMicroseconds(230);                    // Short delay to allow capacitor charge in QTI module
	DDRD &= B00001111;                         // Set direction of pins D4-D7 as INPUT
	PORTD &= B00001111;                        // Set level of pins D4-D7 to LOW
	delayMicroseconds(230);                    // Short delay
	int pins = PIND;                           // Get values of pins D0-D7
	pins >>= 4;                                // Drop off first four bits of the port; keep only pins D4-D7
  
	// Determine how to steer based on state of the four QTI sensors
	switch(pins) {                             // Compare pins to known line following states
		case B1000:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
		  break;
		case B1100:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
			break;
		case B0100:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
			break;
		case B0110:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
			break;
		case B0010:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
			break;
		case B0011:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD - 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD - 1;
			break;
		case B0001:                        
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD - 1;
			break;
		default:
			comp->fmiBuffer.realBuffer[FMI_FARLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDLEFTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_MIDRIGHTVAL] = THRESHOLD + 1;
			comp->fmiBuffer.realBuffer[FMI_FARRIGHTVAL] = THRESHOLD + 1;
			break;
	}

	fmi2DoStep(instance, now, step, false);
	now = now + step;
  
	double vL = 1400 + 500 * (comp->fmiBuffer.realBuffer[FMI_SERVOLEFTOUT]);
	double vR = 1600 + 500 * (comp->fmiBuffer.realBuffer[FMI_SERVORIGHTOUT]);
  
	// Steer robot to recenter it over the line
	servoL.writeMicroseconds((int)vL);
	servoR.writeMicroseconds((int)vR);
  
	delay(50);                                // Delay for 50 milliseconds (1/20 second)
}

