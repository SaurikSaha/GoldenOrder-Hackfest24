# GoldenOrder-Hackfest24

### Problem Statement:
In today's frantic pace, people struggle to balance numerous responsibilities, leaving little time for fitness. This compromise on health highlights the urgent need for accessible solutions that seamlessly integrate exercise into busy lifestyles. Time constraints make it essential for options that fit into fragmented schedules. Whether it's a quick workout during a break or a brief yoga session before bed, these solutions must adapt to accommodate limited time. By addressing these constraints, individuals can reclaim control over their well-being, fostering improved fitness and vitality within the relentless whirlwind of modern life.

The simplest solution can be provided by a fitness trainer as a mobile application .

### Approach: 
Our aim is to develop an application which helps a user to select workouts from a wide range of physical exercises and also helps the user to keep record of the number of exercises / repetitions of exercise performed. The application also assists the user with yoga. It helps maintain proper posture by providing necsessary tips to improve the posture, and gives an accuracy rating, thus, providing a flexible solution to the above stated problem.
By utilizing the mobile camera, the application captures live video streams of the user performing exercises or yoga. State-of-the-art machine learning algorithms analyze these streams to provide real-time feedback on form and count the number of repetitions completed accurately by the user.

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
A trained CNN model is used to detect the posture of the user and judge the correctness of the pose of the user. The user can a pose for a specifc interval of time.
These models are deployed in the backend using flask to create a local server which receives the images provided by the mobile camera in the application and then processes the images accordingly.
The mobile application provides an interactive UI which assists the users to choose the exercise they want to perform, clicking on which initiates the machine learning models deployed in the backend servers.

### User Interface:
<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/0a838345-5449-4afb-a5c8-4e9cc11ac57f" alt="App Screenshot" width="200">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/555ff13d-dad9-4580-9aa4-5ef92686866a" alt="App Screenshot" width="200">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/c1b0dcf8-77bb-42e4-9409-0eb20919e91a" alt="App Screenshot" width="200">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/06bc8517-5e07-4c29-a971-a4af7cf8b2a7" alt="App Screenshot" width="200">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/16f42864-8487-45f9-b323-7c9ce4fe3d1c" alt="App Screenshot" width="200">
  <img src="https://github.com/SaurikSaha/GoldenOrder-Hackfest24/assets/125977973/ee5ef862-dda1-4009-904b-d616b233c1c0" alt="App Screenshot" width="200">
</div>
