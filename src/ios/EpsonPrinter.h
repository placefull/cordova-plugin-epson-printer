#import <Cordova/CDVPlugin.h>
#import "ePOSPrint.h"

@interface EpsonPrinter : CDVPlugin

- (void) connect:(CDVInvokedUrlCommand*)command;

@end