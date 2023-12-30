import numpy as np
import matplotlib.pyplot as plt

import skimage.segmentation as seg
from skimage import filters
from skimage import draw
from skimage import color
from skimage import exposure
from skimage import io
from skimage import morphology

def getSegment(image, borderY=[], borderX=[], threshhold=0.1):

    # image = io.imread(imagePath)
    imageHSV = color.rgb2hsv(image)
    # imageSobel = filters.sobel(imageHSV[...,0])

    seedPoint = (550, 830)

    r = np.array(borderY)
    c = np.array(borderX)
    rr, cc = draw.polygon(r, c, shape=image.shape[:2])
    maskPoly = np.zeros(imageHSV.shape[:2], dtype=bool)
    maskPoly[rr, cc] = 1

    if borderX == [] or borderY == []:
        imageMasked = imageHSV[...,0]
    else:
        imageMasked = imageHSV[...,0] * maskPoly

    floodMask = seg.flood(imageMasked, seedPoint, tolerance=threshhold)
    
    # imageHSVCopy[floodMask, 0] = 1

    # fig, ax = image_show(image)
    # ax.imshow(floodMask, alpha=0.3)
    # plt.show()

    # return color.hsv2rgb(imageHSVCopy)
    return floodMask

# getSegment('testImg/img1.jpg', [330, 750, 750 ,330], [1010, 1010, 185, 185], 0.055)
