

# "C:\Users\khare\OneDrive\Desktop\New folder\The Perfect Push Up _ Do it right! (online-video-cutter.com) (1).mp4"



#updated




import cv2
import mediapipe as mp
import numpy as np
mp_drawing = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose

def calculate_angle(a,b,c):
    a = np.array(a) 
    b = np.array(b)
    c = np.array(c) 
    
    radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
    angle = np.abs(radians*180.0/np.pi)
    
    if angle >180.0:
        angle = 360-angle
        
    return angle 
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



def preprocessing():
        ret, frame = cap.read()
        frame=cv2.flip(frame,1)
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
      
        # Make detection
        results = pose.process(image)
    
        # Recolor back to BGR
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

cap = cv2.VideoCapture(0)
# cap = cv2.VideoCapture('The Perfect Push Up _ Do it right! (online-video-cutter.com) (1).mp4')
# cap = cv2.VideoCapture('The Perfect Push Up _ Do it right! (online-video-cutter.com).mp4')
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280) #to 480 x 720 
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

counter = 0 
stage = None

with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
    while cap.isOpened():
        ret, frame = cap.read()
        frame=cv2.flip(frame,1)
        # Recolor image to RGB
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False
      
        # Make detection
        results = pose.process(image)
    
        # Recolor back to BGR
        image.flags.writeable = True
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        
        try:
            landmarks = results.pose_landmarks.landmark
            
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
    

            if angle_ref2 < 100:
                cv2.putText(image, 'Stance not proper !', (320,150), 2, 2, (0,0,0),2, cv2.LINE_AA)
            
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
                    #print(counter)
                    # if counter == 10:
                        # break

            else:
                if v1<0.40: 
                    cv2.putText(image, 'Elbow not visible', (320,60), 2, 2, (0,0,0),2, cv2.LINE_AA)
                if v4<0.40:
                    cv2.putText(image, 'Knees not visible', (315,105), 2, 2, (0,0,0),2, cv2.LINE_AA)

            #copy for left

            if v5>=0.40 and v6>=0.40 and v7>=0.40 and v8>=0.40:
                if a1 <100 and ar1<15:
                    stage = "down"
                if a1 > 120 and stage =='down':
                    stage="up"
                    counter +=1
                    #print(counter)
                    # if counter == 10:
                        # break

            else:
                if v5<0.40: 
                    cv2.putText(image, 'Elbow not visible', (320,60), 2, 2, (0,0,0),2, cv2.LINE_AA)
                if v8<0.40:
                    cv2.putText(image, 'Knees not visible', (315,105), 2, 2, (0,0,0),2, cv2.LINE_AA)
                    
        except:
            pass 
        
        
        #print(np.multiply(wrist,[1280,720]))

        # Visibility things
        
        #print("elbow: ",landmarks[mp_pose.PoseLandmark.LEFT_ELBOW.value].visibility)
        #print("shoulder",landmarks[mp_pose.PoseLandmark.LEFT_SHOULDER.value].visibility)
        
        cv2.rectangle(image, (0,0), (300,75), (245,117,16), -1)
        
        # Rep data
        cv2.putText(image, 'REPS', (15,12), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,0), 1, cv2.LINE_AA)
        cv2.putText(image, str(counter), 
                    (10,65), 
                    cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)
        
        # Stage data
        cv2.putText(image, 'STAGE', (160,12), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,0), 1, cv2.LINE_AA)
        cv2.putText(image, stage, 
                    (120,65), 
                    cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)
        
        
        # Render detections
        mp_drawing.draw_landmarks(image, results.pose_landmarks, mp_pose.POSE_CONNECTIONS,
                                mp_drawing.DrawingSpec(color=(0,0,0), thickness=2, circle_radius=1), 
                                mp_drawing.DrawingSpec(color=(255,255,0), thickness=1, circle_radius=2) 
                                 )               
        
        cv2.imshow('Mediapipe Feed', image)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()
