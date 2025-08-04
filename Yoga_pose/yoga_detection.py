# coding: utf-8

# In[25]:


import cv2
import mediapipe as mp
import numpy as np
from tensorflow.keras.models import load_model


model = load_model('yoga-91.04.h5')
    


# In[2]:


model.summary()


# In[26]:


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


# In[64]:


def preprocess(image):
    # image = cv2.imread(image_path)
    temp = image
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    image = cv2.resize(image, (210, 200))
    image_arr = image.astype("float32")/255.0
    image_arr = np.expand_dims(image, axis=0)
    return image_arr , image , temp


# cap = cv2.VideoCapture(0)
# cap = cv2.VideoCapture('Learn Yoga - Surya Namaskar(1) (online-video-cutter.com).mp4')
cap = cv2.VideoCapture('21 Suryanamaskar _ Follow along Sun Salutations 25 min workout (online-video-cutter.com).mp4')

cap.set(cv2.CAP_PROP_FRAME_WIDTH, 2048) #to 480 x 720 
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 1152)

while cap.isOpened():
        ret, frame = cap.read()
        # frame=cv2.flip(frame,1)
        # Recolor image to RGB
        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        preprocessed_image , image ,temp = preprocess(image)
        
        
        # Make prediction
        predictions = model.predict(preprocessed_image)
        # print(predictions)
        c1 = -1
        idx1 = -1
        c2 = -1
        idx2 = -1
        c3 = -1
        idx3 = -1
        print(predictions.shape)
        for i in range(len(predictions[0])):
            if predictions[0][i]>c1:
                c1 = predictions[0][i]
                idx1 = i

        for i in range(len(predictions[0])):
            if predictions[0][i]>=c2 and i!=idx1:
                c2 = predictions[0][i]
                idx2 = i
        
        avg = 0.0213
        c1 = c1/ (avg*2 + c1)
        # c2 = c2 - avg
    
        c1*=100
        c2*=100
        c1 = int(c1)
        predicted_class = labels[np.argmax(predictions)]
        # labels[np.argmax(predictions)] = -1
        predicted_class2 = labels[idx2]
        # labels[np.argmax(predictions)] = -1
        
        # predicted_class1 = labels[np.argmax(predictions)]
        # labels[predicted_class3] = -1
        # Output results
        print(f"Predicted Class: {predicted_class}")
        # Make detection
        # results = pose.process(image)
        for i in range(2):
            alpha , beta = cap.read()
        # cv2.putText(temp, str(predicted_class), (10,60), 2, 1, (0,0,0),2, cv2.LINE_AA)
        cv2.putText(temp, str(predicted_class) + " " + str(c1) + "%", (130,25), 2, 1, (0,0,0),1, cv2.LINE_AA)
        # cv2.putText(temp, str(predicted_class2) + " " + str(c2), (10,80), 1, 2, (0,0,0),2, cv2.LINE_AA)
        # cv2.putText(temp, str(predicted_class2), (10,100), 1, 2, (0,0,0),2, cv2.LINE_AA)
        # Recolor back to BGR
        # image.flags.writeable = True
        temp = cv2.cvtColor(temp, cv2.COLOR_RGB2BGR)
        cv2.imshow('Hello_World',temp)
        if cv2.waitKey(10) & 0xFF == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()


# In[ ]:





# In[ ]:




