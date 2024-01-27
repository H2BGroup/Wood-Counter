from kivy.app import App
from kivy.uix.screenmanager import Screen

class StackVolumeScreen(Screen):

    def loadImage(self):
        app = App.get_running_app()
        image = self.ids['thumbnail']
        image.source = app.imageSrc
        image.reload()

    def on_enter(self, *args):
        self.loadImage()
        self.calculateStackVolume()

    def calculateStackVolume(self):
        app = App.get_running_app()
        stack_volume = (float(app.stack_area) * float(app.log_length) * 1000) /  1000000000
        self.ids['stackVolumeField'].text = "is " + str(round(stack_volume,3)) + " m³"
        