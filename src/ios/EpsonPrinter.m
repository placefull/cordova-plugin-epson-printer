//
//  EpsonPrinter.m
//  POSaBit Testing
//
//  Created by Jordan Matthews on 11/11/16.
//
//

#import "EpsonPrinter.h"

#define SEND_TIMEOUT    10 * 1000

@implementation EpsonPrinter

EposPrint* printer;
EposBuilder *builder;
int printerType;

- (int)getBuilderAlign:(int)align {
    switch(align){
        case 1:
            return EPOS_OC_ALIGN_CENTER;
        case 2:
            return EPOS_OC_ALIGN_RIGHT;
        case 0:
        default:
            return EPOS_OC_ALIGN_LEFT;
    }
}

- (int)getBuilderLanguage:(int)lang {
    switch(lang){
        case 1:
            return EPOS_OC_LANG_JA;
        case 2:
            return EPOS_OC_LANG_ZH_CN;
        case 3:
            return EPOS_OC_LANG_ZH_TW;
        case 4:
            return EPOS_OC_LANG_KO;
        case 5:
            return EPOS_OC_LANG_TH;
        case 6:
            return EPOS_OC_LANG_VI;
        case 0:
        default:
            return EPOS_OC_LANG_EN;
    }
}

- (int)getBuilderFont:(int)font {
    switch(font){
        case 1:
            return EPOS_OC_FONT_B;
        case 2:
            return EPOS_OC_FONT_C;
        case 3:
            return EPOS_OC_FONT_D;
        case 4:
            return EPOS_OC_FONT_E;
        case 0:
        default:
            return EPOS_OC_FONT_A;
    }
}

- (int)getBuilderType:(int)cut {
    switch(cut){
        case 1:
            return EPOS_OC_CUT_FEED;
        case 0:
        default:
            return EPOS_OC_CUT_NO_FEED;
    }
}

- (void)connect:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* plug;
        
        //get open parameter
        NSString* ipAddress = [command.arguments objectAtIndex:0];
        if(ipAddress == nil || ipAddress.length == 0){
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
        }
        
        if (!printer) {
            printer = [[EposPrint alloc] init];
            printerType = EPOS_OC_DEVTYPE_TCP;
            if(printer == nil){
                plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize"];
            }
        }
        int result = [printer openPrinter:printerType DeviceName:ipAddress];
        if(result != EPOS_OC_SUCCESS) {
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could open printer at that port"];
        } else {
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
    }];
}

-(void)createBuilder:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* plug;
        if (!builder) {
            builder = [[EposBuilder alloc] initWithPrinterModel:[command.arguments objectAtIndex:0] Lang:EPOS_OC_MODEL_ANK];
            if(builder == nil){
                plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize"];
            }
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
    }];
    
}

- (void) removeBuilder:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [builder clearCommandBuffer];
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
    
}

- (void)addText:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addText:[command.arguments objectAtIndex:0]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not add text"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addTextAlign:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextAlign:[self getBuilderAlign:(int)[command.arguments objectAtIndex:0]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not align text"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addTextLang:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextLang:[self getBuilderLanguage:(int)[command.arguments objectAtIndex:0]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set language"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addTextSmooth:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextSmooth:(int)[command.arguments objectAtIndex:0]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set smooth text"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addFeedLine:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addFeedLine:(long)[command.arguments objectAtIndex:0]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not add feed line"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

//(long)width Height:(long)height;
- (void) addTextSize:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextSize:(long)[command.arguments objectAtIndex:0] Height:(long)[command.arguments objectAtIndex:1]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set text size"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

//(int)reverse Ul:(int)ul Em:(int)em Color:(int)color;
- (void) addTextStyle:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextStyle:(int)[command.arguments objectAtIndex:0] Ul:(int)[command.arguments objectAtIndex:1] Em:(int)[command.arguments objectAtIndex:2] Color:(int)[command.arguments objectAtIndex:3]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set text style"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

//(int)font;
- (void) addTextFont:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextFont:[self getBuilderFont:(int)[command.arguments objectAtIndex:0]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set text font"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

//(int)type;
- (void) addCut:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addCut:[self getBuilderType:(int)[command.arguments objectAtIndex:0]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not cut"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void) sendToPrinter:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    unsigned long status = 0;
    unsigned long battery = 0;
    int result = [printer sendData:builder Timeout:SEND_TIMEOUT Status:&status Battery:&battery];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not print"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
    
}

@end