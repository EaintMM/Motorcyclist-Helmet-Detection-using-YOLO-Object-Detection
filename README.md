# Motorcyclist-Helmet-Detection-using-YOLO-Object-Detection-Network
A system for motorcyclist helmet detection using Gaussian Mixture Model, Morphological operation and YOLO object detection networks.
This is an academic project named "Helmet First". 
The system accepts CCTV record videos as input.It first detects moving frame using Gaussian Mixture Model(GMM) which is one of the foreground detection methods. Then the system determines whether the frame contains motorcyclist or not using YOLO(You Only Look Once) object detection network. Using YOLO again, the system detects helmets in the frame containing motorcycle.If there is no helmet , plate is detected using YOLO for recording to take futher actions such as collection fine. The plates are collected in a folder with date and time.
The system also has a statistics part which tells the data for the number of wearing helmet and non-wearing helemt.The data is saved in excel sheet.
Maily used theories are Gaussian Mixture Model for foreground detection method, some morphological operations and YOLO v2 object detection.
The whole project is developed using Matlab Programming Language.
