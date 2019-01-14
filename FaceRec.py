import cv2
import face_recognition
import os
from string import digits
from time import sleep, time


def capture(img_name):
    print("Starting Face Capture....")
    print("Look at the WebCam")
    sleep(3)
    cam = cv2.VideoCapture(0)
    cv2.namedWindow("God's Eye")
    img_counter = 0

    while True:
        ret, frame = cam.read()
        cv2.imshow("test", frame)
        if not ret:
            break
        k = cv2.waitKey(1)

        if k % 256 == 27:
            # ESC pressed
            print("Escape hit, closing...")
            break

        if img_counter % 10 == 0:
            img = f"{img_name}{img_counter}.jpg"
            cv2.imwrite(img, frame)
            print(f"{img} written!")

        img_counter += 1
        if img_counter > 100:
            break

    cam.release()

    cv2.destroyAllWindows()


def matchFace(dir):
    known_face_encodings = []
    known_face_names = []

    for face in os.listdir(dir):
        face_image = face_recognition.load_image_file(dir + "/" + face)
        encodings = face_recognition.face_encodings(face_image)
        if len(encodings) > 0:
            face_encoding = encodings[0]
            known_face_encodings.append(face_encoding)
            face = face.translate(digits)
            known_face_names.append(face)

    face_locations = []
    face_encodings = []
    face_names = []
    process_this_frame = True

    timeout = 15.0
    start_time = time()

    cam = cv2.VideoCapture(0)
    cv2.namedWindow("God's Eye")

    found = False

    while (time() - start_time) < timeout:
        ret, frame = cam.read()

        small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

        rgb_small_frame = small_frame[:, :, ::-1]

        face_locations = face_recognition.face_locations(rgb_small_frame)
        face_encodings = face_recognition.face_encodings(
            rgb_small_frame, face_locations)

        face_names = []
        name = "Unknown"
        for face_encoding in face_encodings:
                matches = face_recognition.face_distance(
                    known_face_encodings, face_encoding)

                matches = matches.tolist()
                min_matches = min(matches)
                threshold = 0.7

                if min_matches < threshold:
                    first_match_index = matches.index(min_matches)
                    name = known_face_names[first_match_index]

                face_names.append(name)

        for (top, right, bottom, left), name in zip(face_locations, face_names):
            top *= 4
            right *= 4
            bottom *= 4
            left *= 4

            cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

            cv2.rectangle(frame, (left, bottom - 35),
                          (right, bottom), (0, 0, 255), cv2.FILLED)
            font = cv2.FONT_HERSHEY_DUPLEX
            cv2.putText(frame, name, (left + 6, bottom - 6),
                        font, 1.0, (255, 255, 255), 1)

        cv2.imshow('Video', frame)

        # Hit 'q' on the keyboard to quit!
        if (cv2.waitKey(1) & 0xFF == ord('q')):
            break
        if name != "Unknown":
            found = True
            break

    cam.release()
    cv2.destroyAllWindows()
    return found
