#import <Cordova/CDVPlugin.h>
#import "ePOSPrint.h"

@interface EpsonPrinter : CDVPlugin

- (void) connect:(CDVInvokedUrlCommand*)command;
- (void) createBuilder:(CDVInvokedUrlCommand *)command;
- (void) removeBuilder:(CDVInvokedUrlCommand *)command;
- (void) addTextLang:(CDVInvokedUrlCommand *)command;
- (void) addTextAlign:(CDVInvokedUrlCommand *)command;
- (void) addText:(CDVInvokedUrlCommand *)command;
- (void) addTextSmooth:(CDVInvokedUrlCommand *)command;
- (void) addFeedLine:(CDVInvokedUrlCommand *)command;
- (void) addTextSize:(CDVInvokedUrlCommand *)command; //(long)width Height:(long)height;
- (void) addTextStyle:(CDVInvokedUrlCommand *)command; //(int)reverse Ul:(int)ul Em:(int)em Color:(int)color;
- (void) addTextFont:(CDVInvokedUrlCommand *)command; //(int)font;
- (void) addCut:(CDVInvokedUrlCommand *)command; //(int)type;
- (void) sendToPrinter:(CDVInvokedUrlCommand *)command;
- (void) addSymbol:(CDVInvokedUrlCommand *)command;
- (void) getStatus:(CDVInvokedUrlCommand *)command;
/*
- (int) addTextLineSpace:(long)linespc;
- (int) addTextRotate:(int)rotate;
- (int) addTextDouble:(int)dw Dh:(int)dh;
- (int) addTextPosition:(long)x;
- (int) addFeedUnit:(long)unit;
- (int) addImage:(UIImage *)data X:(long)x Y:(long)y Width:(long)width Height:(long)height Color:(int)color;
- (int) addImage:(UIImage *)data X:(long)x Y:(long)y Width:(long)width Height:(long)height Color:(int)color Mode:(int)mode Halftone:(int)halftone Brightness:(double)brightness;
- (int) addImage:(UIImage *)data X:(long)x Y:(long)y Width:(long)width Height:(long)height Color:(int)color Mode:(int)mode Halftone:(int)halftone Brightness:(double)brightness Compress:(int)compress;
- (int) addLogo:(long)key1 Key2:(long)key2;
- (int) addBarcode:(NSString *)data Type:(int)type Hri:(int)hri Font:(int)font Width:(long)width Height:(long)height;
- (int) addSymbol:(NSString *)data Type:(int)type Level:(int)level Width:(long)width Height:(long)height Size:(long)size;
- (int) addHLine:(long)x1 X2:(long)x2 Style:(int)style;
- (int) addVLineBegin:(long)x Style:(int)style;
- (int) addVLineEnd:(long)x Style:(int)style;
- (int) addPageBegin;
- (int) addPageEnd;
- (int) addPageArea:(long)x Y:(long)y Width:(long)width Height:(long)height;
- (int) addPageDirection:(int)dir;
- (int) addPagePosition:(long)x Y:(long)y;
- (int) addPageLine:(long)x1 Y1:(long)y1 X2:(long)x2 Y2:(long)y2 Style:(int)style;
- (int) addPageRectangle:(long)x1 Y1:(long)y1 X2:(long)x2 Y2:(long)y2 Style:(int)style;
- (int) addCut:(int)type;
- (int) addPulse:(int)drawer Time:(int)time;
- (int) addSound:(int)pattern Repeat:(long)repeat;
- (int) addSound:(int)pattern Repeat:(long)repeat Cycle:(long)cycle;
- (int) addCommand:(NSData *)data;
- (int) addFeedPosition:(int)position;
- (int) addLayout:(int)type Width:(long)width Height:(long)height MarginTop:(long)marginTop MarginBottom:(long)marginBottom OffsetCut:(long)offsetCut OffsetLabel:(long)offsetLabel;
*/
@end