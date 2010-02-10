//
//  bundle.m
//  ÇPROJECTNAMEÈ
//
//  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
//  Copyright ÇORGANIZATIONNAMEÈ ÇYEARÈ. All rights reserved.
//

#import <Python/Python.h>
#import <Cocoa/Cocoa.h>

@interface ÇPROJECTNAMEASIDENTIFIERÈBundleLoader {}

+(void)load;

@end

@implementation ÇPROJECTNAMEASIDENTIFIERÈBundleLoader

+(void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSBundle *bundle = [NSBundle bundleForClass:self];
    [bundle load];
    
    NSArray *possibleBundleExtensions = [NSArray arrayWithObjects: @"py", @"pyc", @"pyo", nil];
    NSString *bundleFilePath = nil;
    
    for (NSString *possibleBundleExtension in possibleBundleExtensions) {
        bundleFilePath = [bundle pathForResource: @"bundle" ofType: possibleBundleExtension];
        if ( bundleFilePath != nil ) break;
    }
    
	if ( !bundleFilePath ) {
        [NSException raise: NSInternalInconsistencyException format: @"%s:%d ÇPROJECTNAMEASIDENTIFIERÈBundleLoader load() Failed to find the bundle.{py,pyc,pyo} file in the bundle wrapper's Resources directory.", __FILE__, __LINE__];
    }
    
    setenv("PYOBJC_BUNDLE_ADDRESS", [[NSString stringWithFormat:@"%p", bundle] UTF8String], 1);
    
    Py_SetProgramName("/usr/bin/python");
    Py_Initialize();
    
    const char *bundleFilePathPtr = [bundleFilePath UTF8String];
    FILE *bundleFile = fopen(bundleFilePathPtr, "r");
    int result = PyRun_SimpleFile(bundleFile, (char *)[@"ÇPROJECTNAMEASIDENTIFIERÈBundleLoader" UTF8String]);
    
    if ( result != 0 )
        [NSException raise: NSInternalInconsistencyException
                    format: @"%s:%d ÇPROJECTNAMEASIDENTIFIERÈBundleLoader load() PyRun_SimpleFile failed with file '%@'.  See console for errors.", __FILE__, __LINE__, bundleFilePath];
    
    [pool drain];
}

@end