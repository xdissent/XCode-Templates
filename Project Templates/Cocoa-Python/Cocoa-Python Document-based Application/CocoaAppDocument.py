#
#  ÇPROJECTNAMEASIDENTIFIERÈDocument.py
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright ÇORGANIZATIONNAMEÈ ÇYEARÈ. All rights reserved.
#

from Foundation import *
from AppKit import *

class ÇPROJECTNAMEASIDENTIFIERÈDocument(NSDocument):
    def init(self):
        self = super(ÇPROJECTNAMEASIDENTIFIERÈDocument, self).init()
        # initialization code
        return self
        
    def windowNibName(self):
        return u"ÇPROJECTNAMEASIDENTIFIERÈDocument"
    
    def windowControllerDidLoadNib_(self, aController):
        super(ÇPROJECTNAMEASIDENTIFIERÈDocument, self).windowControllerDidLoadNib_(aController)

    def dataOfType_error_(self, typeName, outError):
        return None, NSError.errorWithDomain_code_userInfo_(NSOSStatusErrorDomain, -4, None) # -4 is unimpErr from CarbonCore
    
    def readFromData_ofType_error_(self, data, typeName, outError):
        return NO, NSError.errorWithDomain_code_userInfo_(NSOSStatusErrorDomain, -4, None) # -4 is unimpErr from CarbonCore
