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

Printer.connect = function (id, success, error) {
    exec(success, error, 'EpsonPrinter', 'connect', [id]);
};


module.exports = Printer;