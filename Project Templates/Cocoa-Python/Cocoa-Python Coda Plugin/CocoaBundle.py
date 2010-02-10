#
#  ÇPROJECTNAMEASIDENTIFIERÈ.py
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright ÇORGANIZATIONNAMEÈ ÇYEARÈ. All rights reserved.
#

import objc
from Foundation import NSObject, NSImage, NSAttributedString, NSBundle
from AppKit import NSApp, NSNibOwner

class ÇPROJECTNAMEASIDENTIFIERÈ(NSObject, objc.protocolNamed('CodaPlugIn')):
    def name(self):
        return 'ÇPROJECTNAMEÈ'

    def initWithPlugInController_bundle_(self, controller, bundle):
        self = super(ÇPROJECTNAMEASIDENTIFIERÈ, self).init()
        if self is not None:
            bundle.loadNibFile_externalNameTable_withZone_('ÇPROJECTNAMEASIDENTIFIERÈ', 
                                                           {NSNibOwner: self}, None)
            controller.registerActionWithTitle_target_selector_('About ÇPROJECTNAMEÈ', 
                                                                self, 'showAboutPlugin:')
        return self

    @objc.IBAction
    def showAboutPlugin_(self, sender):
        icon = None
        info = objc.currentBundle().infoDictionary()
        if 'CFBundleIconFile' in info:
            icon_file = info['CFBundleIconFile']
            icon_path = objc.currentBundle().pathForImageResource_(icon_file)
            if icon_path is not None:
                icon = NSImage.alloc().initWithContentsOfFile_(icon_path)
        if icon is None:
            icon = NSImage.imageNamed_('NSApplicationIcon')
        options = {'Credits': NSAttributedString.alloc().initWithString_('ÇFULLUSERNAMEÈ'),
                   'ApplicationName': self.name(),
                   'ApplicationIcon': icon,
                   'ApplicationVersion': info['CFBundleShortVersionString'],
                   'Version': 'Coda %s' % NSBundle.mainBundle().infoDictionary()['CFBundleShortVersionString']}
        NSApp.orderFrontStandardAboutPanelWithOptions_(options)