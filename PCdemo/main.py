from kivy.app import App
from kivy.uix.screenmanager import ScreenManager
import threshholdscreen, select_point_screen, draw_border_screen, choose_image_screen, select_plate_screen, log_length_screen, stack_volume_screen

class Screens(ScreenManager):
    pass

class WoodCounter(App):
    imageSrc = ''
    borderX = []
    borderY = []
    
if __name__ == '__main__':
    WoodCounter().run()