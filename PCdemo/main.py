from kivy.app import App
from kivy.uix.screenmanager import ScreenManager
import threshholdscreen, select_point_screen

class Screens(ScreenManager):
    pass

class WoodCounter(App):
    imageSrc = 'testImg/img1.jpg'
    
if __name__ == '__main__':
    WoodCounter().run()