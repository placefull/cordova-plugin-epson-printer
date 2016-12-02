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

- (int)getBuilderStyle:(int)style {
	switch(style) {
		case 1:
			return EPOS_OC_TRUE;
		case 2:
			return EPOS_OC_PARAM_UNSPECIFIED;
		case 0:
		default:
			return EPOS_OC_FALSE;
	}
}

- (int)getBuilderColor:(int)color {
	switch(color) {
		case 1:
			return EPOS_OC_COLOR_1;
		case 2:
			return EPOS_OC_PARAM_UNSPECIFIED;
		case 0:
		default:
			return EPOS_OC_COLOR_NONE;
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

- (int)getSymbolType:(int)type {
    switch(type){
        case 1:
            return EPOS_OC_SYMBOL_PDF417_TRUNCATED;
        case 2:
            return EPOS_OC_SYMBOL_QRCODE_MODEL_1;
        case 3:
            return EPOS_OC_SYMBOL_QRCODE_MODEL_2;
        case 4:
            return EPOS_OC_SYMBOL_MAXICODE_MODE_2;
        case 5:
            return EPOS_OC_SYMBOL_MAXICODE_MODE_3;
        case 6:
            return EPOS_OC_SYMBOL_MAXICODE_MODE_4;
        case 7:
            return EPOS_OC_SYMBOL_MAXICODE_MODE_5;
        case 8:
            return EPOS_OC_SYMBOL_MAXICODE_MODE_6;
        case 9:
            return EPOS_OC_SYMBOL_GS1_DATABAR_STACKED;
        case 10:
            return EPOS_OC_SYMBOL_GS1_DATABAR_STACKED_OMNIDIRECTIONAL;
        case 11:
            return EPOS_OC_SYMBOL_GS1_DATABAR_EXPANDED_STACKED;
        case 12:
            return EPOS_OC_SYMBOL_AZTECCODE_FULLRANGE;
        case 13:
            return EPOS_OC_SYMBOL_AZTECCODE_COMPACT;
        case 14:
            return EPOS_OC_SYMBOL_DATAMATRIX_SQUARE;
        case 15:
            return EPOS_OC_SYMBOL_DATAMATRIX_RECTANGLE_8;
        case 16:
            return EPOS_OC_SYMBOL_DATAMATRIX_RECTANGLE_12;
        case 17:
            return EPOS_OC_SYMBOL_DATAMATRIX_RECTANGLE_16;
        case 0:
        default:
            return EPOS_OC_SYMBOL_PDF417_STANDARD;
    }
}

- (int)getSymbolLevel:(int)level {
    switch(level) {
        case 0:
            return EPOS_OC_LEVEL_0;
        case 1:
            return EPOS_OC_LEVEL_1;
        case 2:
            return EPOS_OC_LEVEL_2;
        case 3:
            return EPOS_OC_LEVEL_3;
        case 4:
            return EPOS_OC_LEVEL_4;
        case 5:
            return EPOS_OC_LEVEL_5;
        case 6:
            return EPOS_OC_LEVEL_6;
        case 7:
            return EPOS_OC_LEVEL_7;
        case 8:
            return EPOS_OC_LEVEL_8;
        case 9:
            return EPOS_OC_LEVEL_L;
        case 10:
            return EPOS_OC_LEVEL_M;
        case 11:
            return EPOS_OC_LEVEL_Q;
        case 12:
            return EPOS_OC_LEVEL_H;
        case 13:
        default:
            return EPOS_OC_LEVEL_DEFAULT;
    }
}

- (int)convertToInt:(NSNumber *)val {
    return val.intValue;
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
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not open printer at that port"];
        } else {
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        }
        [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
    }];
}

- (void)getStatus:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    unsigned long status = 0;
    unsigned long battery = 0;
    EposBuilder *builder2 = [[EposBuilder alloc] initWithPrinterModel:[command.arguments objectAtIndex:0] Lang:EPOS_OC_MODEL_ANK];
    if(builder2 == nil){
        return ;
    }
    int result = [printer sendData:builder2 Timeout:0 Status:&status Battery:&battery];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Not connected"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [builder2 clearCommandBuffer];
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

-(void)createBuilder:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* plug;
        if (!builder) {
            builder = [[EposBuilder alloc] initWithPrinterModel:[command.arguments objectAtIndex:0] Lang:EPOS_OC_MODEL_ANK];
            plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            if(builder == nil){
                plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize"];
            }
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
    int result = [builder addTextAlign:[self getBuilderAlign:[self convertToInt:[command.arguments objectAtIndex:0]]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not align text"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addSymbol:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addSymbol:[command.arguments objectAtIndex:0] Type:[self getSymbolType:[self convertToInt:[command.arguments objectAtIndex:1]]] Level:[self getSymbolLevel:[self convertToInt:[command.arguments objectAtIndex:2]]] Width:EPOS_OC_PARAM_UNSPECIFIED Height:EPOS_OC_PARAM_UNSPECIFIED Size:[self convertToInt:[command.arguments objectAtIndex:2]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not add symbol"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addTextLang:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextLang:[self getBuilderLanguage:[self convertToInt:[command.arguments objectAtIndex:0]]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set language"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addTextSmooth:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextSmooth:(bool)[command.arguments objectAtIndex:0]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not set smooth text"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

- (void)addFeedLine:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addFeedLine:[self convertToInt:[command.arguments objectAtIndex:0]]];
    if(result != EPOS_OC_SUCCESS){
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not add feed line"];
    } else {
        plug = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:plug callbackId:[command callbackId]];
}

//(int)width Height:(int)height;
- (void) addTextSize:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* plug;
    int result = [builder addTextSize:[self convertToInt:[command.arguments objectAtIndex:0]] Height:[self convertToInt:[command.arguments objectAtIndex:1]]];
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
    int result = [builder addTextStyle:[self getBuilderStyle:[self convertToInt:[command.arguments objectAtIndex:0]]] Ul:[self getBuilderStyle:[self convertToInt:[command.arguments objectAtIndex:1]]] Em:[self getBuilderStyle:[self convertToInt:[command.arguments objectAtIndex:2]]] Color:[self getBuilderColor:[self convertToInt:[command.arguments objectAtIndex:0]]]];
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
    int result = [builder addTextFont:[self getBuilderFont:[self convertToInt:[command.arguments objectAtIndex:0]]]];
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
    int result = [builder addCut:[self getBuilderType:[self convertToInt:[command.arguments objectAtIndex:0]]]];
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