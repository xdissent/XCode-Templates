//
//  PyLoader.m
//
//  Created by Greg Thornton on 1/16/09.
//  Copyright 2010 Remarkable Wit. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Python/Python.h>

@interface PyLoader {}

+(void)load;

@end

@implementation PyLoader

+(void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSBundle *bundle;
    NSString *module, *modulePath;
    FILE *fp;
    PyObject *m, *d, *v;
    
    // Find and load the application bundle
    bundle = [NSBundle bundleForClass:self];
    [bundle load];
    
    // Keep track of the loaded bundle
    setenv("PYOBJC_BUNDLE_ADDRESS", [[NSString stringWithFormat:@"%p", bundle] UTF8String], 1);
    
    // Find the Python module to load
    module = [[bundle infoDictionary] objectForKey:@"PyLoader Module"];
    
    if (module == NULL) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"No PyLoader Module specified", bundle];
    }
    
    // Find the path to the Python module
    modulePath = [bundle pathForResource:module ofType:@"py"];
    
    if (modulePath == NULL) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"Cannot find Python module in bundle", bundle];
    }
    
    // Initialize Python    
    if (!Py_IsInitialized()) {
        Py_Initialize();
    }
    
    // Open the Python module
    fp = fopen([modulePath cStringUsingEncoding:[NSString defaultCStringEncoding]], "r");
    if (fp == NULL) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"Cannot open Python module in bundle", bundle];
    }
    
    // Create a Python module namespace for the PyLoader
    m = PyImport_AddModule("__main_PyLoader__");
    if (m == NULL) {
        PyErr_Print();
        [NSException raise:NSInternalInconsistencyException 
                    format:@"Cannot create main module for bundle", bundle];
    }
    
    // Add default attributes to the PyLoader module
    PyModule_AddStringConstant(m, "__file__", 
                               (char*)[modulePath 
                                       cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    PyModule_AddStringConstant(m, "__path__", 
                               (char*)[[bundle resourcePath] 
                                       cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    
    // Get the module contents as a dict
    d = PyModule_GetDict(m);
    if (d == NULL) {
        PyErr_Print();
        [NSException raise:NSInternalInconsistencyException 
                    format:@"Failed to retrieve PyLoader module dict", bundle];
    }
    
    // Ensure Python builtins are loaded into the PyLoader module
    if (PyDict_GetItemString(d, "__builtins__") == NULL) {
        
        // Load the builtins explicitly
        PyObject* bimod = PyImport_ImportModule("__builtin__");
        if (bimod == NULL || PyDict_SetItemString(d, "__builtins__", bimod) != 0) {
            PyErr_Print();
            [NSException raise:NSInternalInconsistencyException 
                        format:@"Failed to load Python builtins", bundle];
        }
        
        // Clean up our reference to the builtins
        Py_XDECREF(bimod);
    }
    
    // Check for an error
    if (PyErr_Occurred()) {
        PyErr_Print();
        [NSException raise:NSInternalInconsistencyException 
                    format:@"A Python error occurred", bundle];
    }
    
    // Load the main Python module in the PyLoader module namespace
    v = PyRun_File(fp, [modulePath cStringUsingEncoding:[NSString defaultCStringEncoding]], Py_file_input, d, d);
    
    // Make sure it worked
    if (v == NULL) {
        PyErr_Print();
        [NSException raise:NSInternalInconsistencyException 
                    format:@"Failed to run Python module", bundle];
    }
    
    // Clean up our reference to the loaded module
    Py_DECREF(v);
    
    // Clean up the Python environment
    if (Py_FlushLine()) {
        PyErr_Clear();
    }
    
    // Cleanup
    [pool drain];
}

@end
