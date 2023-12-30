from kivy.app import App
from kivy.uix.screenmanager import Screen
import segmentation
from PIL import Image as im 
import numpy as np
from io import BytesIO
from kivy.core.image import Image as CoreImage

class ThreshholdScreen(Screen):
    imageSrc = 'testImg/img1.jpg'
    borderY = [330, 750, 750 ,330]
    borderX = [1010, 1010, 185, 185]
    DEFAULT_THRESHHOLD = 0.01

    def on_kv_post(self, base_widget):
        image = self.ids['imageOriginal']
        image.source = self.imageSrc
        image.reload()

        self.imageData = im.open(self.imageSrc)
        self.onThreshholdChange(self.DEFAULT_THRESHHOLD)
        
    def onThreshholdChange(self, threshhold):
        mask= segmentation.getSegment(np.array(self.imageData), self.borderY, self.borderX, threshhold)

        imageData = im.fromarray((mask * 255).astype(np.uint8))
        buffer = BytesIO()
        imageData.save(buffer, format='png')
        buffer.seek(0)

        imageWidget = self.ids['imageMask']
        imageWidget.texture = CoreImage(BytesIO(buffer.read()), ext='png').texture
        imageWidget.reload()