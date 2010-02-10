#
#  ___PROJECTNAMEASIDENTIFIER___Plugin.py
#  ___PROJECTNAME___
#
#  Created by ___FULLUSERNAME___ on ___DATE___.
#  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
#

import objc
from Foundation import *
from AppKit import *

class ___PROJECTNAMEASIDENTIFIER___Plugin(NSObject, objc.protocolNamed('CodaPlugIn')):
    pluginWindow = objc.IBOutlet()

    def name(self):
        return '___PROJECTNAME___'
        
    def initWithPlugInController_bundle_(self, controller, bundle):
        self = super(___PROJECTNAMEASIDENTIFIER___Plugin, self).init()
        if self is not None:
            bundle.loadNibFile_externalNameTable_withZone_('___PROJECTNAMEASIDENTIFIER___', {NSNibOwner: self}, None)
        return self