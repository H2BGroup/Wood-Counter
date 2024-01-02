from kivy.app import App
from kivy.uix.screenmanager import Screen
import segmentation
from PIL import Image as im
import numpy as np
from io import BytesIO
from kivy.core.image import Image as CoreImage

class ThreshholdScreen(Screen):
    # borderY = [330, 750, 750 ,330]
    # borderX = [1010, 1010, 185, 185]
    DEFAULT_THRESHHOLD = 0.01

    def on_kv_post(self, base_widget):
        pass
   
    def on_enter(self, *args):
        app = App.get_running_app()
        image = self.ids['imageOriginal']
        image.source = app.imageSrc
        image.reload()

        app = App.get_running_app()
        print(app.imageX, app.imageY)
        self.imageData = im.open(app.imageSrc)
        self.onThreshholdChange(self.DEFAULT_THRESHHOLD)

    def onThreshholdChange(self, threshhold):
        app = App.get_running_app()
        mask= segmentation.getSegment(np.array(self.imageData), app.borderY, app.borderX, threshhold, seedPoint=(app.imageY, app.imageX))

        imageData = im.fromarray((mask * 255).astype(np.uint8))
        buffer = BytesIO()
        imageData.save(buffer, format='png')
        buffer.seek(0)

        imageWidget = self.ids['imageMask']
        imageWidget.texture = CoreImage(BytesIO(buffer.read()), ext='png').texture
        imageWidget.reload()

        app.mask = mask