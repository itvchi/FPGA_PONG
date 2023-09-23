import numpy as np
import cv2
import sys

if len(sys.argv) == 2:
    tile_no = int(sys.argv[1])
    img = cv2.imread('Untitled.png') # Load the image
    height, width, channels = img.shape
    print("Show tile_no: " + str(tile_no))
    tile = img[tile_no*4:(tile_no + 1)*4]
    tile = cv2.resize(tile, None, fx=16, fy=16, interpolation=cv2.INTER_NEAREST)
    cv2.imshow("Image", tile) # Display the image
    cv2.waitKey(0) # Wait for the user to press a key