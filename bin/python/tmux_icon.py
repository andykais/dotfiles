class TrayIcon:

    def __init__(self, appid, icon, menu):
        self.menu = menu

        APPIND_SUPPORT = 1
        try:
            from gi.repository import AppIndicator3
        except:
            APPIND_SUPPORT = 0

        if APPIND_SUPPORT == 1:
            self.ind = AppIndicator3.Indicator.new(
                appid, icon, AppIndicator3.IndicatorCategory.APPLICATION_STATUS)
            self.ind.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
            self.ind.set_menu(self.menu)
        else:
            self.ind = Gtk.StatusIcon()
            self.ind.set_from_file(icon)
            self.ind.connect('popup-menu', self.onPopupMenu)

    def onPopupMenu(self, icon, button, time):
        self.menu.popup(None, None, Gtk.StatusIcon.position_menu, icon, button, time)
