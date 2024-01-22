from kivy.app import App
from kivy.uix.screenmanager import Screen
from kivy.graphics import Ellipse
from utils import getRelativeImageCoordinates
import segmentation
from PIL import Image as im
import numpy as np
from io import BytesIO
from kivy.core.image import Image as CoreImage

THRESHHOLD = 0.05
PLATE_AREA_MM = 1161

class SelectPlateScreen(Screen):

    def loadImage(self):
        app = App.get_running_app()
        image = self.ids['imageOriginal']
        image.source = app.imageSrc
        image.reload()

    def on_enter(self, *args):
        self.loadImage()
        

    def imagePressed(self, touch):
        if self.ids['imageOriginal'].collide_point(*touch.pos):
            x, y = getRelativeImageCoordinates(self.ids['imageOriginal'], touch)
            app = App.get_running_app()
            app.imageX = int(x)
            app.imageY = int(y)
            if x is not None and y is not None:
                self.ids['pointCanvas'].canvas.clear()            
                with self.ids['pointCanvas'].canvas:
                    d = 5
                    Ellipse(pos=(touch.x - d/2, touch.y-d/2), size=(d,d))
                self.ids['continueButton'].disabled = False
                self.ids['imageMask'].opacity = 0.3

    
    def calcualtePlateArea(self):
        app = App.get_running_app()
        self.imageData = im.open(app.imageSrc)
        mask = segmentation.getSegment(np.array(self.imageData), app.borderY, app.borderX, THRESHHOLD, seedPoint=(app.imageY, app.imageX))

        imageData = im.fromarray((mask * 255).astype(np.uint8))
        buffer = BytesIO()
        imageData.save(buffer, format='png')
        buffer.seek(0)

        app.plate_area = np.count_nonzero(mask)
        print (app.plate_area)

        app.conversion_rate = PLATE_AREA_MM / app.plate_area
        print (app.conversion_rate)

        imageWidget = self.ids['imageMask']
        imageWidget.texture = CoreImage(BytesIO(buffer.read()), ext='png').texture
        imageWidget.reload()

        app.mask = mask