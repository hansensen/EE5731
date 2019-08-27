from skimage import io, viewer
img = io.imread('image.jpg', as_gray=True)  # load the image as grayscale
print('image matrix size:', img.shape)     # print the size of image
print('\n First 5 columns and rows of the image matrix: \n', img[:5,:5]*255)
viewer.ImageViewer(img).show()              # plot the image
