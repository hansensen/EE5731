import cv2
import numpy as np
import matplotlib.pyplot as plt
from skimage import io, color
from skimage import exposure
img = io.imread('image.jpg')    # Load the image
img = color.rgb2gray(img)       # Convert the image to grayscale (1 channel)
kernel = np.array([[0,-1,0],[-1,5,-1],[0,-1,0]])
image_sharpen = cv2.filter2D(img,-1,kernel)
print '\n First 5 columns and rows of the image_sharpen matrix: \n', image_sharpen[:5,:5]*255
# Adjust the contrast of the filtered image by applying Histogram Equalization 
image_sharpen_equalized = exposure.equalize_adapthist(image_sharpen/np.max(np.abs(image_sharpen)), clip_limit=0.03)
plt.imshow(image_sharpen_equalized, cmap=plt.cm.gray)
plt.axis('off')
plt.show()
