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
    PRINTER_INIT_STATUS_CONNECT_SUCCESS = 2,
    PRINTER_INIT_STATUS_CONNECT_FAIL = 3
};
//
@interface EpsonPrinter : CDVPlugin <Epos2DiscoveryDelegate, Epos2PtrStatusChangeDelegate>
{
    Epos2Printer *printer_;
    Epos2FilterOption *filterOption_;
    NSMutableArray *printerList_;
    int printerConnection;
	int printerModel;
    int printerInitializingStatus; // 0 not initialize, 1 initializing, 2 connected
	NSString * ipAddress; // Wifi printers
	NSString * macAddress; // BT printers
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
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    if (printer_ == nil) {
        printerInitializingStatus = PRINTER_INIT_STATUS_INITIALIZING;

        printerModel = [[command.arguments objectAtIndex:0] integerValue]; // 0 WIFI, 1 BLUETOOTH
        switch (printerModel) {
			case EPOS2_TM_M30:
				printer_ = [[Epos2Printer alloc] initWithPrinterSeries:EPOS2_TM_M30 lang:EPOS2_MODEL_ANK];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				break;

			case EPOS2_TM_T88:
				printer_ = [[Epos2Printer alloc] initWithPrinterSeries:EPOS2_TM_T88 lang:EPOS2_MODEL_ANK];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				break;

			case EPOS2_TM_P80:
				printer_ = [[Epos2Printer alloc] initWithPrinterSeries:EPOS2_TM_P80 lang:EPOS2_MODEL_ANK];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				break;

			default:
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not initialize printer"];
				break;
		}
		filterOption_ = nil;
		filterOption_ = [[Epos2FilterOption alloc] init];
		printerList_ = nil;
		printerList_ = [[NSMutableArray alloc] init];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) deinitializePrinter:(CDVInvokedUrlCommand *)command
{
    printer_ = nil;
    printerConnection = nil;
	printerModel = nil;
    printerInitializingStatus = PRINTER_INIT_STATUS_NOT_INITIALIZED;
	//ipAddress = nil;
	//macAddress = nil;
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

- (bool) isBluetoothPrinterConnection
{
	return printerConnection == 1;
}

- (bool) isWifiPrinterConnection
{
	return printerConnection == 0;
}

- (bool) isMacAddressSaved
{
	return macAddress != nil && macAddress != @"";
}

- (bool) isIpAddressSaved
{
	return ipAddress != nil && ipAddress != @"";
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
    NSString *connectString = nil;
	if ([self isBluetoothPrinterConnection]) {
		if ([self isMacAddressSaved]) {
            [self connectBluetooth:macAddress];

			if (printerInitializingStatus == PRINTER_INIT_STATUS_CONNECT_SUCCESS) {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
				return;
			}
		}
		filterOption_.portType = EPOS2_PORTTYPE_BLUETOOTH;


	} else if ([self isWifiPrinterConnection]) {
		if ([self isIpAddressSaved]) {
            [self connectWifi:ipAddress];

			if (printerInitializingStatus == PRINTER_INIT_STATUS_CONNECT_SUCCESS) {
				pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
				return;
			}
		}
		filterOption_.portType = EPOS2_PORTTYPE_TCP;
		filterOption_.broadcast = (NSString*) [command.arguments objectAtIndex:1];


    } else {
		printerInitializingStatus = PRINTER_INIT_STATUS_CONNECT_FAIL;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was nil or invalid printer connection"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
    }

	// printer does not have cached device address and needs to be discovered
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

- (void)saveIpAddress:(CDVInvokedUrlCommand *)command
{
	ipAddress = (NSString*) [command.arguments objectAtIndex:0];
}

- (void)saveMacAddress:(CDVInvokedUrlCommand *)command
{
	macAddress = (NSString*) [command.arguments objectAtIndex:0];
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

    if([status getPaper] == EPOS2_PAPER_EMPTY) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt: PRINTER_STATUS_PAPER_ERROR];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) onDiscovery:(Epos2DeviceInfo *)deviceInfo
{
    [printerList_ addObject:deviceInfo];
    NSString *connectString = nil;
    if ([self isBluetoothPrinterConnection]) {
		macAddress = [deviceInfo getBdAddress];
        [self connectBluetooth:macAddress];
    }
    else if ([self isWifiPrinterConnection]) {
		ipAddress = [deviceInfo getIpAddress];
        [self connectWifi:ipAddress];
    }

}

- (void) connectBluetooth:(NSString *) macAddress
{
    int result = [printer_ connect:[NSString stringWithFormat: @"BT:%@", macAddress] timeout:EPOS2_PARAM_DEFAULT];
    if (result == EPOS2_CODE_SUCCESS) {
		printerInitializingStatus = PRINTER_INIT_STATUS_CONNECT_SUCCESS;
	} else {
		printerInitializingStatus = PRINTER_INIT_STATUS_CONNECT_FAIL;
	}
}

- (void) connectWifi:(NSString *) ipAddress
{
    int result = [printer_ connect:[NSString stringWithFormat: @"TCP:%@", ipAddress] timeout:EPOS2_PARAM_DEFAULT];
    if (result == EPOS2_CODE_SUCCESS) {
		printerInitializingStatus = PRINTER_INIT_STATUS_CONNECT_SUCCESS;
	} else {
		printerInitializingStatus = PRINTER_INIT_STATUS_CONNECT_FAIL;
	}
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
    if ([self isBluetoothPrinterConnection]) {
        connectString = [NSString stringWithFormat: @"BT:%@", [firstValidPrinter getBdAddress]];
    }
    else if ([self isWifiPrinterConnection]) {
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
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Could not end transaction"];
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
