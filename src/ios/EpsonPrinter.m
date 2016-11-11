//
//  EpsonPrinter.m
//  POSaBit Testing
//
//  Created by Jordan Matthews on 11/11/16.
//
//

#import "EpsonPrinter.h"

@implementation EpsonPrinter

- (void)connect:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* result;
    [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
}

@end