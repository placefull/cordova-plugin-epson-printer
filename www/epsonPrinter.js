var exec = require("cordova/exec");

/**
 * The Cordova plugin ID for this plugin.
 */
var PLUGIN_ID = "EpsonPrinter";

/**
 * The plugin which will be exported and exposed in the global scope.
 */
var Printer = function () { };



/**
 * Blocks user input using an indeterminate spinner.
 * 
 * An optional label can be shown below the spinner.
 * 
 * @param [string] labelText - The optional value to show in a label.
 * @param [options] options - The optional options object used to customize behavior.
 * @param [function] successCallback - The success callback for this asynchronous function.
 * @param [function] failureCallback - The failure callback for this asynchronous function; receives an error string.
 */

//takes the IP address of the printer
Printer.connect = function (id, success, error) {
    exec(success, error, 'EpsonPrinter', 'connect', [id]);
};

//need to pass in the builder model, string
Printer.createBuilder = function (model, success, error) {
    exec(success, error, 'EpsonPrinter', 'createBuilder', [model]);
};

Printer.getStatus = function (model, success, error) {
    exec(success, error, 'EpsonPrinter', 'getStatus', [model]);
};

Printer.removeBuilder = function (success, error) {
    exec(success, error, 'EpsonPrinter', 'removeBuilder', []);
};

//need to pass the string to add text
Printer.addText = function (text, success, error) {
    exec(success, error, 'EpsonPrinter', 'addText', [text]);
};

//need to pass in the ENUM for printer align
Printer.addTextAlign = function (align, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextAlign', [align]);
};

//need to pass in the ENUM for printer language
Printer.addTextLang = function (lang, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextLang', [lang]);
};

Printer.addSymbol = function (address, type, level, size, success, error) {
    exec(success, error, 'EpsonPrinter', 'addSymbol', [address, type, level, size]);
}

//need to pass in boolean for text smoothing
Printer.addTextSmooth = function (smooth, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextSmooth', [smooth]);
};

//need to number of lines to feed
Printer.addFeedLine = function (line, success, error) {
    exec(success, error, 'EpsonPrinter', 'addFeedLine', [line]);
};

//takes a number from 1-8 (width, height)
Printer.addTextSize = function (width, height, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextSize', [width, height]);
};

//Uses ENUM for values
//int reverse = Specifies inversion of black and white for text. 
//int ul = Specifies the underline style.
//int em = Specifies the bold style.
//int color = Specifies the color
Printer.addTextStyle = function (reverse, ul, em, color, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextStyle', [reverse, ul, em, color]);
};

//need to pass in the ENUM for printer font
Printer.addTextFont = function (font, success, error) {
    exec(success, error, 'EpsonPrinter', 'addTextFont', [font]);
};

//need to pass in the ENUM for printer cut
Printer.addCut = function (cut, success, error) {
    exec(success, error, 'EpsonPrinter', 'addCut', [cut]);
};

Printer.sendToPrinter = function (success, error) {
    exec(success, error, 'EpsonPrinter', 'sendToPrinter', []);
};

module.exports = Printer;