
def getRelativeImageCoordinates(image, touch):
    lr_space = (image.width - image.norm_image_size[0]) / 2  # empty space in Image widget left and right of actual image
    tb_space = (image.height - image.norm_image_size[1]) / 2  # empty space in Image widget above and below actual image
    print('lr_space =', lr_space, ', tb_space =', tb_space)
    print("Touch Cords", touch.x, touch.y)
    print('Size of image within ImageView widget:', image.norm_image_size)
    print('ImageView widget:, pos:', image.pos, ', size:', image.size)
    print('image extents in x:', image.x + lr_space, image.right - lr_space)
    print('image extents in y:', image.y + tb_space, image.top - tb_space)
    pixel_x = touch.x - lr_space - image.x  # x coordinate of touch measured from lower left of actual image
    pixel_y = image.y + image.norm_image_size[1] - touch.y - tb_space  # y coordinate of touch measured from lower left of actual image
    if pixel_x < 0 or pixel_y < 0:
        print('clicked outside of image\n')
        return None, None
    elif pixel_x > image.norm_image_size[0] or \
            pixel_y > image.norm_image_size[1]:
        print('clicked outside of image\n')
        return None, None
    else:
        print('clicked inside image, coords:', pixel_x, pixel_y)

        # scale coordinates to actual pixels of the Image source
        print('actual pixel coords:',
            pixel_x * image.texture_size[0] / image.norm_image_size[0],
            pixel_y * image.texture_size[1] / image.norm_image_size[1], '\n')

        x = pixel_x * image.texture_size[0] / image.norm_image_size[0]
        y = pixel_y * image.texture_size[1] / image.norm_image_size[1]
        return x, y