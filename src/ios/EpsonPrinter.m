/********* EpsonPrinter.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "ePOS2.h"
#import "ePOSEasySelect.h"


// Custom definitions, linked with PF.PrinterStatus in Common.js
enum PrinterStatus : int {
	PRINTER_STATUS_CONNECTED = 0,
    PRINTER_STATUS_NULL_PRINTER = 1,
    PRINTER_STATUS_NOT_CONNECTED = 2,
    PRINTER_STATUS_NOT_ONLINE = 3,
    PRINTER_STATUS_BATTERY_ERROR = 4, 
    PRINTER_STATUS_PAPER_ERROR = 5, 
    PRINTER_STATUS_INITIALIZING = 6
};

enum PrinterInitializingStatus : int {
	PRINTER_INIT_STATUS_NOT_INITIALIZED = 0,
    PRINTER_INIT_STATUS_INITIALIZING = 1,
    PRINTER_INIT_STATUS_CONNECTED = 2,
};
//
@interface EpsonPrinter : CDVPlugin <Epos2DiscoveryDelegate, Epos2PtrStatusChangeDelegate>
{
  	Epos2Printer *printer_;
    Epos2FilterOption *filterOption_;
    NSMutableArray *printerList_;
    int printerConnection;
	int printerInitializingStatus; // 0 not initialize, 1 initializing, 2 connected
}

@end

@implementation EpsonPrinter

- (void) startMonitoring:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    [printer_ setStatusChangeEventDelegate:self];
	[printer_ setInterval:3000];
	int result = [printer_ startMonitor];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not start monitoring for printer"];
    } else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	
}

- (void) stopMonitoring:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ stopMonitor];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not stop monitoring for printer"];
    } else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	
}

-(void) onPtrStatusChange:(Epos2Printer *)printerObj eventType:(int)eventType
{
	switch (eventType) {
		case EPOS2_EVENT_ONLINE:
			break;
		case EPOS2_EVENT_OFFLINE:
			break;
		case EPOS2_EVENT_POWER_OFF:
			break;
		case EPOS2_EVENT_COVER_CLOSE:
			break;
		case EPOS2_EVENT_COVER_OPEN:
			break;
		case EPOS2_EVENT_PAPER_OK:
			break;
		case EPOS2_EVENT_PAPER_NEAR_END:
			break;
		case EPOS2_EVENT_PAPER_EMPTY:
			break;
		case EPOS2_EVENT_DRAWER_HIGH:
			break;
		case EPOS2_EVENT_DRAWER_LOW:
			break;
		case EPOS2_EVENT_BATTERY_ENOUGH:
			break;
		case EPOS2_EVENT_BATTERY_EMPTY:
			break;
		default:
			break;
	}
}

- (void) initializePrinter:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	//pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    if (printer_ == nil) {
		printerInitializingStatus = PRINTER_INIT_STATUS_INITIALIZING;

		printerConnection = [[command.arguments objectAtIndex:0] integerValue]; // 0 WIFI, 1 BLUETOOTH
		
        if (printerConnection == 1) {
            printer_ = [[Epos2Printer alloc] initWithPrinterSeries:EPOS2_TM_M30 lang:EPOS2_MODEL_ANK];
			if (printer_ == nil) {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize printer"];
			} else {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			}
        }
        
        else if (printerConnection == 0) {
            printer_ = [[Epos2Printer alloc] initWithPrinterSeries:EPOS2_TM_T88 lang:EPOS2_MODEL_ANK];
			if (printer_ == nil) {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize printer"];
			} else {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			}
        } else {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was nil"];
		}
    }
    
	//[printer_ setReceiveEventDelegate:self];
	filterOption_ = nil;
    filterOption_ = [[Epos2FilterOption alloc] init];
	printerList_ = nil;
    printerList_ = [[NSMutableArray alloc] init];
    
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) deinitializePrinter:(CDVInvokedUrlCommand *)command
{
	printer_ = nil;
	printerConnection = nil;
	printerInitializingStatus = PRINTER_INIT_STATUS_NOT_INITIALIZED;
}

- (void) clearCommandBuffer:(CDVInvokedUrlCommand *)command
{
	CDVPluginResult* pluginResult = nil;
	int result = nil;
	if (printer_ == nil) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not clear command buffer, printer is nil"];
    } else {
		result = [printer_ clearCommandBuffer];
		if (result != EPOS2_SUCCESS) {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not clear command buffer for printer"];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
		}
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void) disconnect:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	int result = nil;
	if (printer_ == nil) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not disconnect printer, printer is nil"];
    } else {
		result = [printer_ disconnect];
		if (result != EPOS2_SUCCESS) {
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not disconnect printer"];

        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			printerInitializingStatus = PRINTER_INIT_STATUS_NOT_INITIALIZED;
        }
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	
}
- (void)startDiscovery:(CDVInvokedUrlCommand *)command

{
    CDVPluginResult* pluginResult = nil;
	printerInitializingStatus = PRINTER_INIT_STATUS_INITIALIZING;
	
	filterOption_ = nil;
	filterOption_ = [[Epos2FilterOption alloc] init];
	filterOption_.deviceModel = EPOS2_MODEL_ALL;
	filterOption_.deviceType = EPOS2_TYPE_PRINTER;

	printerConnection = [[command.arguments objectAtIndex:0] integerValue];
	if (printerConnection == 1) {
		filterOption_.portType = EPOS2_PORTTYPE_BLUETOOTH;
		
	} else if (printerConnection == 0) {
		filterOption_.portType = EPOS2_PORTTYPE_TCP;
		filterOption_.broadcast = (NSString*) [command.arguments objectAtIndex:1];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was nil or invalid printer connection"];
	}

    int result = [Epos2Discovery start:filterOption_ delegate:self];
    if (result != EPOS2_CODE_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to start discovery for printer"];
		
    } else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
   
    
}
- (void)stopDiscovery:(CDVInvokedUrlCommand *)command

{
    CDVPluginResult* pluginResult = nil;
	int result = [Epos2Discovery stop];
	if (result != EPOS2_CODE_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to stop discovery for printer"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getConnection:(CDVInvokedUrlCommand *)command 
{
    CDVPluginResult* pluginResult = nil;
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: PRINTER_STATUS_CONNECTED];
	if (printer_ == nil ) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_NULL_PRINTER];
	}

	if (printerInitializingStatus == PRINTER_INIT_STATUS_INITIALIZING) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_INITIALIZING];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	Epos2PrinterStatusInfo *status = [printer_ getStatus];
	if([status getConnection] != EPOS2_TRUE) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_NOT_CONNECTED];
	}
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getStatus:(CDVInvokedUrlCommand *)command 
{
    CDVPluginResult* pluginResult = nil;
	pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: PRINTER_STATUS_CONNECTED];
	
	if (printer_ == nil ) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_NULL_PRINTER];
	}
	if (printerInitializingStatus == PRINTER_INIT_STATUS_INITIALIZING) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_INITIALIZING];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}

	Epos2PrinterStatusInfo *status = [printer_ getStatus];
	if([status getConnection] != EPOS2_TRUE) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_NOT_CONNECTED];
	}
	if([status getOnline] != EPOS2_TRUE) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_NOT_ONLINE];
	}

	if([status getBatteryLevel] == EPOS2_BATTERY_LEVEL_6) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_BATTERY_ERROR];
	}

	if([status getPaper] != EPOS2_PAPER_OK) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_PAPER_ERROR];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) onDiscovery:(Epos2DeviceInfo *)deviceInfo
{
	[printerList_ addObject:deviceInfo];
    NSString *connectString = nil;
    if (printerConnection == 1) {
        connectString = [NSString stringWithFormat: @"BT:%@", [deviceInfo getBdAddress]];
    }
    else if (printerConnection == 0) {
        connectString = [NSString stringWithFormat: @"TCP:%@", [deviceInfo getIpAddress]];
    }
    [printer_ connect:connectString timeout:EPOS2_PARAM_DEFAULT];
	printerInitializingStatus = PRINTER_INIT_STATUS_CONNECTED;
}

- (void) connectWifi:(CDVInvokedUrlCommand *)command
{
	NSString *connectString = [NSString stringWithFormat: @"TCP:%@", [command.arguments objectAtIndex:0]];
    [printer_ connect:connectString timeout:EPOS2_PARAM_DEFAULT];
	
}

- (void) connect:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	printerConnection = [[command.arguments objectAtIndex:0] integerValue];
	if (printerList_ == nil || [printerList_ count] == 0) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No printer discovered to connect to"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
	}
	Epos2DeviceInfo* firstValidPrinter = (Epos2DeviceInfo *)[printerList_ objectAtIndex:0];

	NSString *connectString = nil;
    if (printerConnection == 1) {
		connectString = [NSString stringWithFormat: @"BT:%@", [firstValidPrinter getBdAddress]];
    }
    else if (printerConnection == 0) {
		connectString = [NSString stringWithFormat: @"TCP:%@", [firstValidPrinter getIpAddress]];
    }
    
    
    int result = [printer_ connect:connectString timeout:EPOS2_PARAM_DEFAULT];
	if (result != EPOS2_CODE_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to connect printer"];

	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)beginTransaction:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ beginTransaction];
    if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not being transaction for printer"];
    } else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)endTransaction:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ endTransaction];
    if (result != EPOS2_SUCCESS) {
        printf("Could not end transaction");
		return;
    } else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)printData:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	if (printer_ == nil) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Failed to print, printer is nil"];

	}
	int result = [printer_ sendData:EPOS2_PARAM_DEFAULT];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not print"];

	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addTextLang:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addTextLang:EPOS2_LANG_EN];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) addTextSmooth:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addTextSmooth:(bool)[command.arguments objectAtIndex:0]];
	if (result != EPOS2_SUCCESS) {
		printf("Fail to create receipt data");
		return;
	}
}

- (void) addTextAlign:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addTextAlign:EPOS2_ALIGN_CENTER];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addTextFont:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addTextFont:EPOS2_FONT_A];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addSymbol:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
    int result = [printer_ addSymbol:[command.arguments objectAtIndex:0]
							   type:EPOS2_SYMBOL_QRCODE_MODEL_2
							  level:EPOS2_LEVEL_L
							  width:(long)[[command.arguments objectAtIndex:3] integerValue]
							 height:(long)[[command.arguments objectAtIndex:4] integerValue]
							   size:(long)[[command.arguments objectAtIndex:5] integerValue]];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addTextSize:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
    int result = [printer_ addTextSize:[[command.arguments objectAtIndex:0] longValue] height:[[command.arguments objectAtIndex:1] longValue]];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addText:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addText:[command.arguments objectAtIndex:0]];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) addFeedLine:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addFeedLine:[[command.arguments objectAtIndex:0] longValue]];
	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addTextStyle:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addTextStyle: [[command.arguments objectAtIndex:0] integerValue] 
									ul: [[command.arguments objectAtIndex:1] integerValue] 
									em: [[command.arguments objectAtIndex:2] integerValue] 
									color: [[command.arguments objectAtIndex:3] integerValue]];

	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addCut:(CDVInvokedUrlCommand *) command 
{
    CDVPluginResult* pluginResult = nil;
	int result = [printer_ addCut: [[command.arguments objectAtIndex:0] integerValue]];

	if (result != EPOS2_SUCCESS) {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Fail to create receipt data"];
	} else {
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
