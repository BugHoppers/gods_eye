import cv2
from time import sleep

def capture(img_name):
    print("Starting Face Capture....")
    print("Look at the WebCam")
    sleep(5)
    cam = cv2.VideoCapture(0)
    cv2.namedWindow("God's Eye")
    img_counter = 0

    while True:
        ret, frame = cam.read()
        cv2.imshow("test", frame)
        if not ret:
            break
        k = cv2.waitKey(1)

        if k%256 == 27:
            # ESC pressed
            print("Escape hit, closing...")
            break

        if img_counter%10 == 0 :
            img = f"{img_name}_{img_counter}.png"
            cv2.imwrite(img, frame)
            print(f"{img} written!")
        
        img_counter += 1
        if img_counter > 100:
            break


    cam.release()

    cv2.destroyAllWindows()
