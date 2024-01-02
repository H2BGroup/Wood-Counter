from kivy.app import App
from kivy.uix.screenmanager import Screen
from kivy.graphics import Ellipse, Line, Color
from utils import getRelativeImageCoordinates

class DrawBorderScreen(Screen):

    touchX = []
    touchY = []

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
            if x is not None and y is not None:
                app.borderX.append(int(x))
                app.borderY.append(int(y))
                self.touchX.append(touch.x)
                self.touchY.append(touch.y)          
                with self.ids['pointCanvas'].canvas:
                    d = 5
                    Color(1, 0, 0)
                    Ellipse(pos=(touch.x - d/2, touch.y-d/2), size=(d,d))
                    Line(points=[touch.x, touch.y, self.touchX[len(self.touchX)-2], self.touchY[len(self.touchY)-2]], width=1.0)
                if len(self.touchX) >= 3 and len(self.touchY) >= 3:
                    self.ids['continueButton'].disabled = False
    
    def clearBorder(self):
        app = App.get_running_app()
        app.borderY = []
        app.borderX = []
        self.touchX = []
        self.touchY = []
        self.ids['pointCanvas'].canvas.clear()
        self.ids['continueButton'].disabled = True