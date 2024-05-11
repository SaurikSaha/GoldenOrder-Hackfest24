# GoldenOrder-Hackfest24

### Problem Statement:
In today's frantic pace, people struggle to balance numerous responsibilities, leaving little time for fitness. This compromise on health highlights the urgent need foraccessible solutions that seamlessly integrate exercise into busy lifestyles. Time constraints make it essential for options that fit into fragmented schedules. Whether it's a quick workout during a break or a brief yoga session before bed, these solutions must adapt to accommodate limited time. By addressing these constraints,individuals can reclaim control over their well-being, fostering improved fitness and vitality within the relentless whirlwind of modern life.

The simplest solution can be provided by a fitness trainer as a mobile application.

### Approach: 
Our aim is to develop an app which helps a user to select workouts from a wide range of physical exercises and also helps the user to keep record of the number of exercises / repetitions of exercise performed. The app also assists the user with yoga and maintain proper posture, thus, providing a flexible solution to the above stated problem.
By utilizing the mobile camera, the app captures live video streams of the user performing exercises or yoga. State-of-the-art machine learning algorithms analyze these streams to provide real-time feedback on form and count the number of repetitions completed accurately by the user.

### Tech Stack:

-Flutter
-Flask 
-Firebase
-Tensorflow
-Pytorch
-Mediapipe
-OpenCv
-NumPy
-SkLearn

### Basic Workflow:
Utilizing mediapipe pose detection model, we extract key points on the human body from video frames. These key points facilitate the identification of the user's stance during exercises. By analyzing these keypoints, the model updates corresponding counter variables for each exercise by keeping track of joint angles while the user moves, and then the counter is updated if the given constraints and conditions are met.
A trained CNN model is used to detect the posture of the user the judge the correctness of the pose of the user. The user can a pose for a specifc interval of time.
These models are deployed in the backend using flask to create a local server which receives the images provided by the mobile camera in the app and then processes the images accordingly.
The mobile app assists the user to choose the exercise he/she wants to perform by the interactive UI provided by the app, clicking on which then initiates the machine learning models deployed in the backend servers.

### User Interface:
![WhatsApp Image 2024-05-11 at 05 51 18_6a0f0c85](https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/138333445/cabc8ba2-14d4-4c9c-bc63-165899d1a590)
