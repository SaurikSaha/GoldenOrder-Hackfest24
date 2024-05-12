
from flask import Flask,request,jsonify
from flask_cors import CORS
import base64
import cv2
import tensorflow as tf
import mediapipe as mp
import numpy as np
from tensorflow import keras
from keras import models
from tensorflow.keras.models import load_model

app = Flask(__name__)
CORS(app)
counter = int(0)
stage = None

def reset_vals():
     global counter
     global stage
     counter = int(0)
     stage= None


@app.route('/curls', methods=['POST'])
def start_camera1():
    
    global counter
    global stage
    print("curls")
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
   
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)
        
                try:
                    # print(counter)
                    landmarks = results.pose_landmarks.landmark
        
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,
                                landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,
                            landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,
                            landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
        
                    angle = calculate_angle(rshoulder, relbow, rwrist)
        
                    # cv2.putText(imager, str(angle),
                    #             tuple(np.multiply(elbow, [720, 480]).astype(int)),
                    #             cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA)
        
                    
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility
                    
                    if v1 >= 0.40 and v2 >= 0.40 and v3 >= 0.40:
                        if angle > 140:
                            stage = "down"
                        if angle < 60 and stage == 'down':
                            stage = "up"
                            counter += 1
                    else:
                        if v1<0.40:
                            cv2.putText(imager, 'Right elbow not visible', (200, 30), 1, 1, (0, 0, 0), 1, cv2.LINE_AA)
        
        
                    
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,
                                landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,
                            landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,
                            landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
        
                    angle = calculate_angle(lshoulder, lelbow, lwrist)
        
                    # cv2.putText(imager, str(angle),
                    #             tuple(np.multiply(elbow, [720, 480]).astype(int)),
                    #             cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA)
        
                    
                    l1 = landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].visibility
                    l2 = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility
                    l3 = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility
                    
                    if l1 >= 0.40 and l2 >= 0.40 and l3 >= 0.40:
                        if angle > 140:
                            stage = "down"
                        if angle < 60 and stage == 'down':
                            stage = "up"
                            counter += 1
                    else:
                        if l1<0.40:
                            cv2.putText(imager, 'Left elbow not visible', (200, 60), 1, 1, (0, 0, 0), 1, cv2.LINE_AA)
        
        
        
                except:
                    pass
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
        
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'


@app.route('/pushups', methods=['POST'])
def start_camera2():
    
    global counter
    global stage
    print("pushups")
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle1(a,b):
        a = np.array(a) # First
        b = np.array(b) # Mid
        c = np.array(b) # End
        if a[0]>b[0]:
            c[0]+=10.0
        else:
            c[0]-=10.0
        # print(b)
        # print(c)
        radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
        angle = np.abs(radians*180.0/np.pi)
        
        if angle >180.0:
            angle = 360-angle
            
        return angle 
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
       
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)

        #touch me here 
                try:
                    landmarks = results.pose_landmarks.landmark
            
            # Get coordinates
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]

                    right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
                    right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y] 
            
            
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]

                    left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
                    left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y] 
            
            # Calculate angle
                    angle = calculate_angle(rshoulder, relbow, rwrist)
                    angle_ref = calculate_angle1(right_hip,right_knee)
            # print(angle_ref)
                    angle_ref2 = calculate_angle(rshoulder,right_hip,right_knee)
        
                    #left parts
                    a1 = calculate_angle(lshoulder, lelbow, lwrist)
                    ar1 = calculate_angle1(left_hip,left_knee)
                    # print(angle_ref)
                    ar2 = calculate_angle(lshoulder,left_hip,left_knee)
                    # Visualize angle
                    # cv2.putText(image, str(angle), 
                    #                tuple(np.multiply(elbow, [1280, 720]).astype(int)), 
                    #                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA
                    #                     )
                    # cv2.putText(image, str(angle_ref), 
                    #                tuple(np.multiply(right_knee, [1280, 720]).astype(int)), 
                    #                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA
                    #                     )
                    
                    
        
                    if angle_ref2 < 100:
                        cv2.putText(imager, 'Stance not proper !', (200,15), 1, 1, (0,0,0),1, cv2.LINE_AA)
                    
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility
                    v4 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
        
                    v5 = landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].visibility
                    v6 = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility
                    v7 = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility
                    v8 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility

                    if v1>=0.40 and v2>=0.40 and v3>=0.40 and v4>=0.40:
                        if angle <100 and angle_ref<15:
                            stage = "down"
                        if angle > 120 and stage =='down':
                            stage="up"
                            counter +=1
                           
        
                    else:
                        if v1<0.40: 
                            cv2.putText(imager, 'Elbow not visible', (200,30), 1, 1, (0,0,0),1, cv2.LINE_AA)
                        if v4<0.40:
                            cv2.putText(imager, 'Knees not visible', (200,50), 1, 1, (0,0,0),1, cv2.LINE_AA)
        
                    #copy for left
        
                    if v5>=0.40 and v6>=0.40 and v7>=0.40 and v8>=0.40:
                        if a1 <100 and ar1<15:
                            stage = "down"
                        if a1 > 120 and stage =='down':
                            stage="up"
                            counter +=1
                           
        
                    else:
                        if v5<0.40: 
                            cv2.putText(imager, 'Elbow not visible', (200,70), 1, 1, (0,0,0),1, cv2.LINE_AA)
                        if v8<0.40:
                            cv2.putText(imager, 'Knees not visible', (200,90), 1, 1, (0,0,0),1, cv2.LINE_AA)
                            
                except:
                    pass

        #critical section 
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'


@app.route('/squats', methods=['POST'])
def start_camera3():
    
    global counter
    global stage
    print("squats")
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
   
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)

        #touch me here 
                try:
                    landmarks = results.pose_landmarks.landmark
                    
                    
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
                    rear = [landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].y]
                    
                    right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
                    right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y] 
                    right_ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y]
                    
                    # Calculate angles
                    angle = calculate_angle(right_hip, right_knee, right_ankle)
                    angle_ref = calculate_angle(rshoulder,relbow,rwrist)
                    angle_ref2=calculate_angle(right_hip,rshoulder,rwrist)
             
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].visibility
                    # v4 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    if angle_ref < 110:
                        cv2.putText(imager, 'Keep your right hand straight', (200,15), 1, 1, (0,0,0),1, cv2.LINE_AA)
                    if v1>=0.40 and v2>=0.40 and v3>=0.40:
                        if angle < 40 and angle_ref>120 and angle_ref2>60:
                            stage = "down"
                        if angle > 120 and stage =='down' and angle_ref>120 and angle_ref2>60:
                            stage="up"
                            counter +=1
                            #print(counter)
                            # if counter == 10:
                                # break
        
                    else:
                        if v2<0.40: 
                            cv2.putText(imager, 'Shoulders not visible', (200,30), 1, 1, (0,0,0),1, cv2.LINE_AA)
                        if v3<0.40:
                            cv2.putText(imager, 'Feet not visible', (200,50), 1, 1, (0,0,0),1, cv2.LINE_AA)
        
        
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
                    lear = [landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].x,landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].y]
                    
                    light_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
                    light_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y] 
                    light_ankle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y]
                    
                    # Calculate angles
                    lngle = calculate_angle(light_hip, light_knee, light_ankle)
                    lngle_ref = calculate_angle(lshoulder,lelbow,lwrist)
                    lngle_ref2=calculate_angle(light_hip,lshoulder,lwrist)
             
                    l1 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
                    l2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    l3 = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].visibility
                    # v4 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    if lngle_ref < 110:
                        cv2.putText(imager, 'Keep your left hand straight', (200,70), 1, 1, (0,0,0),1, cv2.LINE_AA)
                    if l1>=0.40 and l2>=0.40 and l3>=0.40:
                        if lngle < 40 and lngle_ref>120 and lngle_ref2>60:
                            stage = "down"
                        if lngle > 120 and stage =='down' and lngle_ref>120 and lngle_ref2>60:
                            stage="up"
                            counter +=1
                            #print(counter)
                            # if counter == 10:
                                # break
        
                    else:
                        if l2<0.40: 
                            cv2.putText(imager, 'Shoulders not visible', (200,30), 1, 1, (0,0,0),1, cv2.LINE_AA)
                        if l3<0.40:
                            cv2.putText(imager, 'Feet not visible', (200,50), 1, 1, (0,0,0),1, cv2.LINE_AA)
                            
                except:
                    pass

        #critical section 
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
        
              
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'


@app.route('/pullups', methods=['POST'])
def start_camera4():
    
    global counter
    global stage
    print("pullups")
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
   
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)

        #touch me here 
                try:
                    landmarks = results.pose_landmarks.landmark
                    
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
                    rear = [landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].y]
                    
                    right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
                    right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y] 
                    
                    angle = calculate_angle(rshoulder, relbow, rwrist)
                  
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility
                    v4 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
        
                    if v1>=0.40 and v2>=0.40 and v3>=0.40:
                        if angle < 40 and rear[1]<rwrist[1]:
                            stage = "up"
                        if angle > 120 and stage =='up':
                            stage="down"
                            counter +=1
        
                    else:
                        if v1<0.40: 
                            cv2.putText(imager, 'Right elbow not visible', (200,15), 1, 1, (0,0,0),1, cv2.LINE_AA)
        
        
        
                    #LEFT HAND SIDE
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
                    lear = [landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].x,landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].y]
                    
                    light_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
                    light_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y] 
                    
                    lngle = calculate_angle(lshoulder, lelbow, lwrist)
                  
                    l1 = landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].visibility
                    l2 = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility
                    l3 = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility
                    l4 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
        
                    if l1>=0.40 and l2>=0.40 and l3>=0.40:
                        if lngle < 40 and lear[1]<lwrist[1]:
                            stage = "up"
                        if lngle > 120 and stage =='up':
                            stage="down"
                            counter +=1
        
                    else:
                        if l1<0.40: 
                            cv2.putText(imager, 'Left elbow not visible', (200,30), 1, 1, (0,0,0),1, cv2.LINE_AA)
                            
                            
                except:
                    pass
        #critical section 
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
        
                   
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'


@app.route('/situps', methods=['POST'])
def start_camera5():
    
    global counter
    global stage
    print("situps")
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
   
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)

        #touch me here 
                try:
                    landmarks = results.pose_landmarks.landmark
                    
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
                    rear = [landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_EAR.value].y]
                    
                    right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
                    right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y] 
                    right_ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y]
                    
                    # Calculate angle
                    angle = calculate_angle(rshoulder, right_hip, right_knee)
                    # angle_ref = calculate_angle1(right_hip,right_knee)
                    # print(angle_ref)
                    angle_ref = calculate_angle(right_hip,right_knee,right_ankle)
        
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].visibility
                    # v4 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    if v1>=0.40 and v2>=0.40 and v3>=0.40:
                        if angle < 60 and angle_ref<55:
                            stage = "up"
                        if angle > 100 and stage =='up' and angle_ref<55:
                            stage="down"
                            counter +=1
                    else:
                        # if v1<0.40:
                        #     cv2.putText(image, 'Shoulders not visible', (320,150), 2, 2, (0,0,0),2, cv2.LINE_AA)
                        if v2<0.40:
                            cv2.putText(imager, 'Shoulders not visible', (200,15), 1, 1, (0,0,0),1, cv2.LINE_AA)
        
        
                    
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
                    lear = [landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].x,landmarks[mp_pose.PoseLandmark.LEFT_EAR.value].y]
                    
                    light_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
                    light_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y] 
                    light_ankle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y]
                    
                    # Calculate angle
                    lngle = calculate_angle(lshoulder, light_hip, light_knee)
                    # angle_ref = calculate_angle1(right_hip,right_knee)
                    # print(angle_ref)
                    lngle_ref = calculate_angle(light_hip,light_knee,light_ankle)
        
                    l1 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    l2 = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility
                    l3 = landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].visibility
                    # v4 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    if l1>=0.40 and l2>=0.40 and l3>=0.40:
                        if lngle < 60 and lngle_ref<55:
                            stage = "up"
                        if lngle > 100 and stage =='up' and lngle_ref<55:
                            stage="down"
                            counter +=1
                    else:
                        # if l1<0.40:
                        #     cv2.putText(image, 'Shoulders not visible', (320,150), 2, 2, (0,0,0),2, cv2.LINE_AA)
                        if l2<0.40:
                            cv2.putText(imager, 'Shoulders not visible', (200,30), 1, 1, (0,0,0),1, cv2.LINE_AA)
                       
                           
                except:
                    pass 
         
                
        #critical section 
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
        
              
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'


@app.route('/jumpingjacks', methods=['POST'])
def start_camera6():

    global counter
    global stage
   
    target = int(request.args.get('target'))
    reset = int(request.args.get('reset'))
    if reset == 1:
         reset_vals()
    
    mp_drawing = mp.solutions.drawing_utils
    mp_pose = mp.solutions.pose
    
    def calculate_angle(a, b, c):
        a = np.array(a)  
        b = np.array(b)  
        c = np.array(c) 
    
        radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
        angle = np.abs(radians * 180.0 / np.pi)
    
        if angle > 180.0:
            angle = 360 - angle
    
        return angle
    
   
    with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
        
                image_bytes = base64.b64decode(request.json['image'])
                fr = np.frombuffer(image_bytes, np.uint8)
                frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
        
               
                imager = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                imager.flags.writeable = False
        
                # print(frame)
                # print(frame.shape)
        
                results = pose.process(imager)
        
                imager.flags.writeable = True
                imager = cv2.cvtColor(imager, cv2.COLOR_RGB2BGR)

        #touch me here 
                try:
                    landmarks = results.pose_landmarks.landmark
                    
                    # Get coordinates
                    rshoulder = [landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].y]
                    relbow = [landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ELBOW.value].y]
                    rwrist = [landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y]
        
                    right_hip = [landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_HIP.value].y]
                    right_knee = [landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].y] 
                    
                    
                    lshoulder = [landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].x,landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].y]
                    lelbow = [landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].y]
                    lwrist = [landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x,landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y]
        
                    left_hip = [landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].x,landmarks[mp_pose.PoseLandmark.LEFT_HIP.value].y]
                    left_knee = [landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].y]
                    
                    right_ankle = [landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.RIGHT_ANKLE.value].y]
                    left_ankle = [landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].x,landmarks[mp_pose.PoseLandmark.LEFT_ANKLE.value].y]
                    
                    # Calculate angles
                    angle_l = calculate_angle(rshoulder, relbow, rwrist)
                    angle_r = calculate_angle(lshoulder, lelbow, lwrist)
                    # print(angle_ref)
                    angle_ref2 = calculate_angle(rwrist,rshoulder,right_hip)
                    angle_ref1 = calculate_angle(lwrist,lshoulder,left_hip)
                    #left parts
                    #a1 = calculate_angle(lshoulder, lelbow, lwrist)
                    #ar1 = calculate_angle1(left_hip,left_knee)
                    # print(angle_ref)
                    #ar2 = calculate_angle(lshoulder,left_hip,left_knee)
                    # Visualize angle
                    # cv2.putText(image, str(angle_ref2), 
                    #                tuple(np.multiply(rshoulder, [1280, 720]).astype(int)), 
                    #                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA
                    #                     )
                    # cv2.putText(image, str(angle_ref1), 
                    #                tuple(np.multiply(lshoulder, [1280, 720]).astype(int)), 
                    #                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA
                    #                     )
                    
                    
        
                    # if angle_ref2 < 100:
                    #     cv2.putText(image, 'Stance not proper !', (320,150), 2, 2, (0,0,0),2, cv2.LINE_AA)
                    
                    v1 = landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility
                    v2 = landmarks[mp_pose.PoseLandmark.RIGHT_SHOULDER.value].visibility
                    v3 = landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].visibility
                    v4 = landmarks[mp_pose.PoseLandmark.RIGHT_KNEE.value].visibility
        
                    v5 = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility
                    v6 = landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility
                    v7 = landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].visibility
                    v8 = landmarks[mp_pose.PoseLandmark.LEFT_KNEE.value].visibility
                    if v1>=0.40 and v2>=0.40 and v3>=0.40 and v4>=0.40 :
                        if angle_ref2 < 30 :
                            stage = "down"
                        if angle_ref2 > 120 and stage =='down':
                            stage="up"
                            counter +=1
                            #print(counter)
                            # if counter == 10:
                                # break
        
                    else:
                        if v4<0.40: 
                            cv2.putText(imager, 'Right Knee not visible', (200,15), 1, 1, (0,0,0),1, cv2.LINE_AA)
                        # if v8<0.40:
                        #     cv2.putText(image, 'Left Knee not visible', (315,105), 2, 2, (0,0,0),2, cv2.LINE_AA)
        
                    #copy for left
        
                    if v5>=0.40 and v6>=0.40 and v7>=0.40 and v8>=0.40:
                        if angle_ref1 <30 :
                            stage = "down"
                        if angle_ref1 > 120 and stage =='down':
                            stage="up"
                            counter +=1
                            #print(counter)
                            # if counter == 10:
                                # break
        
                    else:
                        if v8<0.40:
                             cv2.putText(imager, 'Left Knee not visible', (200,30), 1,1, (0,0,0),1, cv2.LINE_AA)
                            
                except:
                    pass

        #critical section 
                cv2.rectangle(imager, (0, 0), (160, 60), (245, 117, 16), -1)
        
                cv2.putText(imager, 'REPS', (7, 11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, str(counter),
                            (5, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                cv2.putText(imager, 'STAGE', (100,11),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.25, (0, 0, 0), 1, cv2.LINE_AA)
                cv2.putText(imager, stage,
                            (80, 40),
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 1, cv2.LINE_AA)
        
                mp_drawing.draw_landmarks(imager, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                        mp_drawing.DrawingSpec(color=(0, 0, 0), thickness=2, circle_radius=1),
                                        mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=1, circle_radius=2))
        
              
                x=int(0)
                if(counter == target):
                     x=1
                _, buffer = cv2.imencode('.jpg', imager)
                processed_image_data = base64.b64encode(buffer).decode('utf-8')
                cv2.destroyAllWindows()
                return jsonify({'processed_image': processed_image_data,'isTarget':x})
    
        
    return 'Camera started'



model = tf.keras.models.load_model("AI_ML\Hackfest\yoga-91.04.h5")

def preprocess(image):
    
    temp = image
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (210, 200))
    image_arr = image.astype("float32")/255.0
    image_arr = np.expand_dims(image, axis=0)
    return image_arr , image , temp


@app.route('/yoga', methods=['POST'])
def start_camera7():

    labels = ["Adho Mukha Svanasana" , 
          "Adho Mukha Vrksasana" , 
          "Alanasana",
         "Anjaneyasana",
         "Ardha Chandrasana",
        "Ardha Matsyendrasana",
          "Ardha Navasana",
          "Ardha Pincha Mayurasana",
          "Ashta Chandrasana",
          "Baddha Konasana",
          "Bakasana",
          "Balasana",
          "Bitilasana",
          "Camatkarasana",
          "Dhanurasana",
          "Eka Pada Rajakapotasana",
          "Garudasana",
          "Halasana",
          "Hanumanasana",
          "Malasana",
          "Marjaryasana",
          "Navasana",
          "Padmasana",
          "Parsva Virabhadrasana",
          "Parsvottanasana",
          "Paschimottanasana",
          "Phalakasana",
          "Pincha Mayurasana",
          "Salamba Bhujangasana",
          "Salamba Sarvangasana",
          "Setu Bandha Sarvangasana",
          "Sivasana",
          "Supta Kapotasana",
          "Trikonasana",
          "Upavistha Konasana",
          "Urdhva Dhanurasana",
          "Urdhva Mukha Svsnssana",
          "Ustrasana",
          "Utkatasana",
          "Uttanasana",
          "Utthita Hasta Padangusthasana",
          "Utthita Parsvakonasana",
          "Vasisthasana",
          "Virabhadrasana One",
          "Virabhadrasana Three",
          "Virabhadrasana Two",
          "Vrksasana"]
    
    pose = str(request.args.get('pose'))
    
    image_bytes = base64.b64decode(request.json['image'])
    fr = np.frombuffer(image_bytes, np.uint8)
    frame = cv2.imdecode(fr, cv2.IMREAD_COLOR)
    
    image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    
    preprocessed_image , image ,temp = preprocess(image)
       
    predictions = model.predict(preprocessed_image) 
    zeros = [[1 , 0 , 1 , 1 , 0, 0 , 0 , 1 , 1, 0, 0, 1 , 1 , 1, 0 , 0 , 1 , 0 , 0 , 1 , 1 , 0 , 1 , 0 , 0 , 1 , 1 , 0 ,  1 , 0 , 0 , 1 , 0 , 1 , 0 , 1 , 1 , 1 , 0 , 1 , 0 , 0 , 1 , 0 , 0 , 0 , 1 ]]
    zeros = np.array(zeros) / 1.0
    # print(predictions.shape)
    predictions = predictions * zeros
    predicted_class = labels[np.argmax(predictions)]

    #Frames 
    print(f"Predicted Class: {predicted_class}")
    for i in range(5):
            # alpha , beta = cap.read()
            _ = base64.b64decode(request.json['image'])


    c1 = predictions[0][np.argmax(predictions)]
    avg = 0.0213
    c1 = c1/(avg*2 + c1)
    c1*=100
    c1 = int(c1)
    if pose=="Adho Mukha Svanasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        elif predicted_class == "Ardha Pincha Mayurasana":
            cv2.putText(temp, "Keep your hands straight", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip: Try to make a mountain with your", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "hands and knees straight", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)
            
    if pose == "Anjaneyasana":
        if predicted_class == pose or predicted_class == "Alanasana" or predicted_class == "Ashta Chandrasana" :
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip: Try to make a crescent moon by fully  ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "stretching your arms and legs", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)
            
    
    if pose == "Balasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip: Lean forward, keeping your buttocks on your heels, ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "and rest your forehead on the floor.", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)


    if pose=="Bitilasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        elif predicted_class == "Marjaryasana":
            cv2.putText(temp,"Keep your back straight", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else :
            cv2.putText(temp, "Tip : Bend over like a cow, ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            #cv2.putText(temp, "and rest your forehead on the floor.", (10,665), 1, 1, (101,69,237),1, cv2.LINE_AA)
 

    if pose == "Garudasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        elif predicted_class == "Vrksasana":
            cv2.putText(temp,"Keep your legs straight", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else :
            cv2.putText(temp, "Tip : Join both hands together and stand straight ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            #cv2.putText(temp, "and rest your forehead on the floor.", (10,665), 1, 1, (101,69,237),1, cv2.LINE_AA)

    
    if pose == "Malasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else :
            cv2.putText(temp, "Tip : Keep your spine straight and your shoulders down  ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, " away from your ears as you squat ", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)


    if pose=="Padmasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else :
            cv2.putText(temp, "Tip : Sit down and cross your legs with each ankle on opposite thigh ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "and keep your back straight ", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)


    if pose == "Phalakasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip : Get down in push up position and hold. ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)


    
    if pose == "Salamba Bhujangasana":
        if predicted_class == pose or predicted_class == "Urdhva Mukha Svsnssana":
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else :
            cv2.putText(temp, "Tip : Lie down face down with legs straight ,  ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "place hands near you chest and lift upper body. ", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)


        
    if pose=="Sivasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip : Lay on your back with palms facing upwards , ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, " keeping your hands close to your body.", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)




    if pose == "Trikonasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        elif predicted_class == "Vasisthasana":
            cv2.putText(temp,"Keep your legs apart", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip :Keep your legs apart with one hand touching the ", (10,650), 1, 1, (101,69,237),1, cv2.LINE_AA)
            cv2.putText(temp, "front feet and the other hand pointing up.", (10,665), 1, 1, (101,69,237),1, cv2.LINE_AA)

            
    if pose == "Urdhva Dhanurasana":
        if predicted_class == pose:
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        elif predicted_class == "Camatkarasana":
            cv2.putText(temp,"Keep both hands on ground and feet together", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)       
        else:
            cv2.putText(temp, "Tip :Lie on your back wiht palms on the groung", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "near you neck and lift body up making an arc.", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)


    if pose == "Ustrasana":
        if predicted_class == pose :
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip : Sit on knees and touch you heels  ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "arching you front body.", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)

    if pose == "Uttanasana":
        if predicted_class == pose or predicted_class == "Paschimottanasana":
            cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,255,25),1, cv2.LINE_AA)
        else:
            cv2.putText(temp, "Tip :Keeping legs straight and try touching  ", (10,650), 1, 1, (0,255,25),1, cv2.LINE_AA)
            cv2.putText(temp, "your knees with forehead.", (10,665), 1, 1, (0,255,25),1, cv2.LINE_AA)

    
    # if pose == predicted_class and predicted_class == "Adho Mukha Svanasana" and c1>70 and c1<86 :
    #     cv2.putText(temp, "Pull hands and head Closer", (130,55), 1, 1, (0,0,0),1, cv2.LINE_AA)
    # if pose == predicted_class and predicted_class== "Phalakasana" and c1>70 and c1<86 :
    #     cv2.putText(temp, "Keep your back straight", (130,55), 1, 1, (0,0,0),1, cv2.LINE_AA)
    # if pose == predicted_class and predicted_class== "Balasana" and c1>70 and c1<86 :
    #     cv2.putText(temp, "Squeeze your body more", (130,55), 1, 1, (0,0,0),1, cv2.LINE_AA)

    # if pose!=predicted_class:
    #     cv2.putText(temp, "Stance not correct", (130,25), 1, 1, (0,0,0),1, cv2.LINE_AA)
    # else:
    #     cv2.putText(temp,"Stance Correctness: " + str(c1) + "%", (130,25), 1, 1, (0,0,0),1, cv2.LINE_AA)
    
    temp = cv2.cvtColor(temp, cv2.COLOR_RGB2BGR)

    _, buffer = cv2.imencode('.jpg', temp)
    processed_image_data = base64.b64encode(buffer).decode('utf-8')
    cv2.destroyAllWindows()
    return jsonify({'processed_image': processed_image_data})
     


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

