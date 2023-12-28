import numpy as np
import matplotlib.pyplot as plt

import skimage.segmentation as seg
from skimage import filters
from skimage import draw
from skimage import color
from skimage import exposure
from skimage import io
from skimage import morphology

def getSegment(imagePath, borderY=[], borderX=[], threshhold=0.1):
    def image_show(image, nrows=1, ncols=1, cmap='gray', **kwargs):
        fig, ax = plt.subplots(nrows=nrows, ncols=ncols, figsize=(16, 16))
        ax.imshow(image, cmap='gray')
        ax.axis('off')
        return fig, ax

    image = io.imread(imagePath)
    imageHSV = color.rgb2hsv(image)
    imageHSVCopy = np.copy(imageHSV)
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

    # mask_postprocessed = np.logical_and(floodMask, imageHSVCopy[..., 1] > 0.4)
    # mask_postprocessed = morphology.binary_opening(mask_postprocessed, np.ones((3, 3)))

    imageHSVCopy[floodMask, 0] = 0.5

    fig, ax = image_show(image)
    ax.imshow(floodMask, alpha=0.3)
    plt.show()

    # return color.hsv2rgb(imageHSVCopy)
    return floodMask

getSegment('testImg/img5.jpg', [150, 720, 730], [845, 1510, 130], 0.055)
