# SOFA_exercises

This MATLAB script, written on Octave version 9.2.0, generates a Gaussian white noise burst with smooth on/offset ramps and creates three spatial trajectories using HRTF data from the South China University of Technology available at https://sofacoustics.org/data/database/scut/. This script relies on the pre-installation of the SOFA toolbox, LFTAT tool box, the NETCDF package, the SIGNAL package (Soundforge) and the 
CONTROL package. 

Instructions:

   1. Enter the initial datapath line 3 and ensure the HRTF data file (SCUT_KEMAR_radius_all.sofa) is located in this data path. If not found, the script prompts the user to enter the correct data path directly in the command prompt, until it can find the proper file to execute the script.

   2. Run the script in MATLAB or Octave (preferably Octave 9.2.0).
     
After generating all the sounds, this script plots 4 figures :

  Figure 1. The spectrogram of the Gaussian white noise burst used to create the following sound trajectories. 

   Figure 2. Spectrograms of an horizontal Clockwise Rotation: The noise burst rotates around the listener at a distance of 1 meter, varying azimuth from 0° to 360°. One spectrogram per ear (2 subplots). 

  Figure 3. Spectrograms of an approach from Left: The noise burst approaches from the left at a fixed azimuth of 90°, with the radius decreasing from 1 meter to 0.2 meters. One spectrogram per ear (2 subplots). 

  Figure 4. Spectrograms of an approach from Front: The noise burst approaches from the front with a fixed azimuth of 0°, and the radius decreases from 1 meter to 0.2 meters. One spectrogram per ear (2 subplots). 
    
Disclaimer: This script is developed solely for the purpose of practicing using the Sofatoolbox as part of an interview process. It is not intended for any other use, including research or other applications.
