import numpy as np
import cv2

img = cv2.imread('Untitled.png')
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
height, width, channels = img.shape

with open("memory.hex", "w") as f:
    for h in range(height):
        for w in range(width):
            print(img[h][w].tobytes().hex(), file=f)