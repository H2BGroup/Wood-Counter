from kivy.app import App
from kivy.uix.screenmanager import Screen
from plyer import filechooser

class ChooseImageScreen(Screen):

    imagePath = ""

    def selectFile(self):
        paths = filechooser.open_file(title="Pick an image file", filters=[["Image", "*jpg", "*png", "*jpeg"]], multiple=False)
        if len(paths) == 1:
            app = App.get_running_app()
            app.imageSrc = paths[0]
            self.ids['imageNameLabel'].text = 'Chosen file: ' + paths[0]
            self.ids['continueButton'].disabled = False      