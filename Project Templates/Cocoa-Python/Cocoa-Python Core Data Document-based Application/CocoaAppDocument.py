#
#  ÇPROJECTNAMEASIDENTIFIERÈDocument.py
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright ÇORGANIZATIONNAMEÈ ÇYEARÈ. All rights reserved.
#

from Foundation import *
from CoreData import *
from AppKit import *

class ÇPROJECTNAMEASIDENTIFIERÈDocument(NSPersistentDocument):
    def init(self):
        self = super(ÇPROJECTNAMEASIDENTIFIERÈDocument, self).init()
        # initialization code
        return self
        
    def windowNibName(self):
        return u"ÇPROJECTNAMEASIDENTIFIERÈDocument"
    
    def windowControllerDidLoadNib_(self, aController):
        super(ÇPROJECTNAMEASIDENTIFIERÈDocument, self).windowControllerDidLoadNib_(aController)
        # user interface preparation code
