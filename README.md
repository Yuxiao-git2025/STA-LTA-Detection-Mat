# STA-LTA-Detection-Mat
Implementation of the `STA/LTA` method
---
A compact MATLAB-based seismic processing method was developed for three-component acceleration records. The method first removes trends and applies zero-phase low-pass and high-pass filtering. The processed acceleration is integrated to obtain velocity and displacement. P-wave arrival is detected using the STA/LTA ratio on the vertical component, while S-wave arrival is estimated from the first strong peak on the horizontal components after the P-wave arrival. <br>
A useful next step is to test several STA/LTA window lengths and threshold values against manually picked P- and S-wave arrivals, then quantify the resulting picking and distance-estimation errors. <br>
<img width="1350" height="1125" alt="Fig1" src="https://github.com/user-attachments/assets/8212c8c2-08e1-485c-be7e-945a5b148819" />
<img width="1350" height="1125" alt="Fig3" src="https://github.com/user-attachments/assets/f474ab89-6171-48b6-86b6-e8b337804d9e" />
