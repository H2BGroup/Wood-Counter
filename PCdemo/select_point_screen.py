from kivy.app import App
from kivy.uix.screenmanager import Screen
from kivy.graphics import Ellipse
from utils import getRelativeImageCoordinates

class SelectPointScreen(Screen):

    def loadImage(self):
        app = App.get_running_app()
        image = self.ids['imageOriginal']
        image.source = app.imageSrc
        image.reload()

    def on_kv_post(self, base_widget):
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