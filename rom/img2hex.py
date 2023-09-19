import numpy as np
import cv2

img = cv2.imread('Untitled.png')
height, width, channels = img.shape

with open("memory.hex", "w") as f:
    for h in range(height):
        for w in range(width):
            print(img[h][w].tobytes().hex(), file=f)