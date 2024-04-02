import os
import requests
import time
import random
import string
import cv2
import warnings
import cv2
import re
import csv
import json
import pickle
import math
import shutil
import face_recognition
import numpy as np
from threading import Thread
from flask import Flask, render_template, request, Response
from flask import redirect, url_for, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
from sklearn import neighbors
from datetime import datetime
from PIL import Image, ImageDraw, ImageFont
from ultralytics import YOLO


#-----------------Camera Attendance Class-----------------#


class CamAttendance:

    NAME = None
    RTSP_url = None
    YOLO_model = None

    extract_folder_path = None
    enhanced_folder_path = None
    capture_folder_path = None

    total_frames = None
    current_frame = None
    time_per_preset = None
    capture_interval = None

    recording_status = None
    presets = None
    

    def setup(self):

        self.RTSP_URL = 'rtsp://172.16.7.132:554'
        self.YOLO_model = YOLO("./yolov8n-face.pt")
        self.capture_folder_path = "captured/"
        self.extract_folder_path = "extracted/"
        self.enhanced_folder_path = "enhanced/"
        self.total_frames = 100
        self.current_frame = 0
        self.time_per_preset = 60*5

        self.capture_interval = self.time_per_preset / self.total_frames
        self.recording_status = False
        self.presets = [1, 2, 3, 4, 5, 6]

        os.makedirs(self.capture_folder_path, exist_ok=True)
        os.makedirs(self.extract_folder_path, exist_ok=True)
        os.makedirs(self.enhanced_folder_path, exist_ok=True)


    def capture_frames(self):

        cap = cv2.VideoCapture(self.RTSP_URL)

        if not cap.isOpened():
            print("Cannot open camera")
            exit()

        frame_count = 0
        try:
            while frame_count < self.total_frames:
                # Wait before capturing the next frame
                time.sleep(self.capture_interval)

                ret, frame = cv2.VideoCapture(self.RTSP_URL).read()

                if not ret:
                    print("Can't receive frame (stream end?). Exiting ...")
                    break

                # Save frame to file
                frame_count += 1
                filename = os.path.join(self.capture_folder_path, f'frame{frame_count}.jpg')
                cv2.imwrite(filename, frame)

                self.extract_faces(filename)
                self.enhance_images(self.extract_folder_path)

                self.recording_status = False

        except Exception as e:
            print("An error occurred:", e)
            self.recording_status = False


    def extract_faces(self, image):

        frame = cv2.imread(image)
        results = self.YOLO_model.predict(source=image)
        
        for result in results:
            # Extract bounding box predictions from the current result
            boxes = result.boxes.xyxy
            image_counter = 0

            for detection in boxes:

                x1, y1, x2, y2 = map(int, detection[:4])
                cropped_face = frame[y1:y2, x1:x2]
                output_filename = f"{self.extract_folder_path}detected_face_{image_counter}.jpg"
                image_counter+=1

                cv2.imwrite(output_filename, cropped_face, [int(cv2.IMWRITE_JPEG_QUALITY), 100])


    def enhance_images(self, input_folder, target_width=256, target_height=256, brightness=1.0, contrast=1.0):

        def enhance_and_resize_image(image, target_width=128, target_height=128, brightness=30, contrast=1.5):      # Enhancement 

            # Enhance brightness and contrast
            enhanced_image = cv2.convertScaleAbs(image, alpha=contrast, beta=brightness)

            # Resize the image to the target size
            dimensions = (target_width, target_height)
            resized_image = cv2.resize(enhanced_image, dimensions, interpolation=cv2.INTER_LINEAR)

            # Optionally apply a sharpening kernel
            sharpening_kernel = np.array([[-1, -1, -1],
                                        [-1, 9, -1],
                                        [-1, -1, -1]])
            sharpened_image = cv2.filter2D(resized_image, -1, sharpening_kernel)

            return sharpened_image
            
        if not os.path.exists(self.enhanced_folder_path):
            os.makedirs(self.enhanced_folder_path)

        # Iterate through all files in the input folder
        for filename in os.listdir(input_folder):
            if filename.lower().endswith(('png', 'jpg', 'jpeg')):
                # Load the image
                file_path = os.path.join(input_folder, filename)
                image = cv2.imread(file_path)

                # Process the image
                processed_image = enhance_and_resize_image(image, target_width, target_height, brightness, contrast)

                # Save the processed image
                output_filename = f"enhanced_{self.current_frame}_{filename}"

                output_path = os.path.join(self.enhanced_folder_path, output_filename)
                self.current_frame+=1
                cv2.imwrite(output_path, processed_image)
                print(f'Processed and saved: {output_path}')



#-----------------Flask API-----------------#



app = Flask(__name__)
CORS(app)


@app.route('/cam_status', methods=['GET'])
def cam_status():
    cam_attendance = CamAttendance()
    cam_attendance.setup()
    return jsonify({'recording_status': cam_attendance.recording_status})


@app.route('/get_attendance', methods=['GET'])
def get_attendance():
    recognized_faces_csv = 'recognized_faces.csv'

    with open(recognized_faces_csv, 'r') as file:
        reader = csv.reader(file)
        data = list(reader)
    return jsonify(data)


@app.route('/start_camera', methods=['GET'])
def start_camera():
    cam_attendance = CamAttendance()
    cam_attendance.setup()

    def capture_frames_and_send_message():
        for i in range(0, 4):
            for preset in cam_attendance.presets:
                requests.get(f'http://172.16.7.132/cgi-bin/ptzctrl.cgi?ptzcmd&poscall&{preset}')
                cam_attendance.recording_status = True
                cam_attendance.capture_frames()
                print(f"capture_frames() called for preset {preset} and iteration {i}")

    thread = Thread(target=capture_frames_and_send_message)
    thread.start()
    
    cam_attendance.recording_status = True

    return jsonify({'message': 'Camera started'})



if __name__ == "__main__":
    app.run(debug=True)
