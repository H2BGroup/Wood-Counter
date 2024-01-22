from kivy.app import App
from kivy.uix.screenmanager import Screen

class LogLengthScreen(Screen):
    def getLogLength(self):
        app = App.get_running_app()
        if len(self.ids['inputField'].text) > 0:
            app.log_length = self.ids['inputField'].text
            self.ids['continueButton'].disabled = False
        else:
            self.ids['continueButton'].disabled = True