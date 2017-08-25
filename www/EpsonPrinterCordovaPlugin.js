var exec = require('cordova/exec');

exports.startMonitoring = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "startMonitoring", []);
};

exports.stopMonitoring = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "stopMonitoring", []);
};

exports.initializePrinter = function (arg0, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "initializePrinter", [arg0]);
};

exports.deinitializePrinter = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "deinitializePrinter", []);
};

exports.disconnect = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "disconnect", []);
};

exports.clearCommandBuffer = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "clearCommandBuffer", []);
};

exports.startDiscovery = function (arg0, arg1, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "startDiscovery", [arg0, arg1]);
};

exports.stopDiscovery = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "stopDiscovery", []);
};

exports.getStatus = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "getStatus", []);
};

exports.getConnection = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "getConnection", []);
};

exports.printData = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "printData", []);
};

exports.connect = function (arg0, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "connect", [arg0]);
};

exports.connectWifi = function (ipAddress, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "connectWifi", [ipAddress]);
};

exports.beginTransaction = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "beginTransaction", []);
};

exports.endTransaction = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "endTransaction", []);
};
exports.createReceiptData = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "createReceiptData", []);
};
exports.printData = function (success, error) {
    cordova.exec(success, error, "EpsonPrinter", "printData", []);
};

exports.addTextLang = function (lang, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextLang", [lang]);
};

exports.addTextSmooth = function (smooth, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextSmooth", [smooth]);
};

exports.addTextAlign = function (x, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextAlign", [x]);
};

exports.addTextFont = function (font, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextFont", [font]);
};
exports.addSymbol = function (address, type, level, width, height, size, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addSymbol", [address, type, level, width, height, size]);
};

exports.addTextSize = function (width, height, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextSize", [width, height]);
};

exports.addText = function (text, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addText", [text]);
};

exports.addFeedLine = function (feedline, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addFeedLine", [feedline]);
};

exports.addTextStyle = function (reverse, ul, em, color, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addTextStyle", [reverse, ul, em, color]);
};

exports.addCut = function (type, success, error) {
    cordova.exec(success, error, "EpsonPrinter", "addCut", [type]);
};