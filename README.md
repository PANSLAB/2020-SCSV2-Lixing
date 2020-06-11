# SCSV2-Lixing
## This is a Self-Calibration Sensing system based on Vibration and Vision, mainly built by Lixing He, supervised by Prof. Shijia Pan. Files: 
## mainfunc:
### load data (requires vibration data, vision data(can have different sample rate) and function to detect footstep) then give the result. beamsrecord: estimated beam locations for each cycles, location: estimated sensors location for each cycles, baseline: estimated sensors location by baseline method.
## testrevise:
### generate 4 figures:
### 1. Association between vibration and vision 2. final result of our method and baseline 3. beams estimation error for all cycles 4. formula test, to show that our physical model is close to data we received.
## findbeam:
### using "footstep location vs signal energy" to find the location of beam
## findlocation:
### using beams and "footstep location vs signal energy" to find locations of sensors
## vibrationfunc:
### our physical model, generate ideal footsteplocation vs signal energy
