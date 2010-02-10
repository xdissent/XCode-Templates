//
//  bundle.m
//  ÇPROJECTNAMEÈ
//
//  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
//  Copyright ÇORGANIZATIONNAMEÈ ÇYEARÈ. All rights reserved.
//

#import <Python/Python.h>
#import <Cocoa/Cocoa.h>

@interface PyBundleLoader {}

+(void)load;

@end

@implementation PyBundleLoader

+(void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSBundle *bundle = [NSBundle bundleForClass:self];
    [bundle load];
    
    NSString *resourcePath = [bundle resourcePath];
    NSArray *pythonPathArray = [NSArray arrayWithObjects: resourcePath, [resourcePath stringByAppendingPathComponent:@"PyObjC"], nil];
    
    setenv("PYTHONPATH", [[pythonPathArray componentsJoinedByString:@":"] UTF8String], 1);
    
    NSArray *possibleBundleExtensions = [NSArray arrayWithObjects: @"py", @"pyc", @"pyo", nil];
    NSString *bundleFilePath = nil;
    
    for (NSString *possibleBundleExtension in possibleBundleExtensions) {
        bundleFilePath = [bundle pathForResource: @"bundle" ofType: possibleBundleExtension];
        if ( bundleFilePath != nil ) break;
    }
    
	if ( !bundleFilePath ) {
        [NSException raise: NSInternalInconsistencyException format: @"%s:%d PyBundleLoader load() Failed to find the bundle.{py,pyc,pyo} file in the bundle wrapper's Resources directory.", __FILE__, __LINE__];
    }
    
    setenv("PYOBJC_BUNDLE_ADDRESS", [[NSString stringWithFormat:@"%p", bundle] UTF8String], 1);
    
    Py_SetProgramName("/usr/bin/python");
    Py_Initialize();
    
    const char *bundleFilePathPtr = [bundleFilePath UTF8String];
    FILE *bundleFile = fopen(bundleFilePathPtr, "r");
    int result = PyRun_SimpleFile(bundleFile, (char *)[[bundleFilePath lastPathComponent] UTF8String]);
    
    if ( result != 0 )
        [NSException raise: NSInternalInconsistencyException
                    format: @"%s:%d PyBundleLoader load() PyRun_SimpleFile failed with file '%@'.  See console for errors.", __FILE__, __LINE__, bundleFilePath];
    
    [pool drain];
}

@end