# fish-detection-and-tracking

## Introduction
Object detection and tracking is a challenging problem in the field of Computer
Vision which has many practical applications such as video surveillance, face
recognition, gesture recognition, robot navigation, augmented reality, etc.
Detection of an object is a challenging task because of the large variations in
parameters like object size along with its positions, changes in background i.e.
dynamic background, illumination effect i.e. lighting conditions along with other
contributing factors. The quality of detection algorithms are improving yet there 
is a struggle to detect occluded objects

## Objectives
* Our main objective is to present an effective method which will locate all the
objects (fish) present in it.
* Track them by examining each and every depth frame obtained from the
Microsoft Kinect V2 recorded underwater video of an aquarium
* Count the number of fishes present in each frame of the recorded video.

## Methodology
* Setting up Kinect V2 Sensor
* Applying Background Subtraction
* Pre-processing Frames
* Applying Clustering Techniques
* Detection and Tracking
* Data Annotation for testing model

## Clustering Techniques used
* K-Means
* DBSCAN
* Fuzzy C Means Clustering

## Results

|   | K-Means | DBSCAN | Fuzzy C Means
| ---|---------|--------|------------
| FP | 3057 | 2867 | 3004
| FN | 1381 | 2354 | 1958
| TP | 5578 | 4770 | 5020
| Precision | 69.83 | 62.58 | 67.59
| Recall | 78.89 | 62.55 | 73.37

