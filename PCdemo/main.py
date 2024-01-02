from kivy.app import App
from kivy.uix.screenmanager import ScreenManager
import threshholdscreen, select_point_screen, draw_border_screen

class Screens(ScreenManager):
    pass

class WoodCounter(App):
    imageSrc = 'testImg/img1.jpg'
    borderX = []
    borderY = []
    
if __name__ == '__main__':
    WoodCounter().run()