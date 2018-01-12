#!/bin/env node
// Node.js application to write a backend API that will run on a Raspberry Pi to allow GPIO switching over networks

// import the required modules
var http = require('http');
var url = require('url');
var querystring = require('querystring');
var gpio = require('./gpioModule.js');

// define constants for various channels
const channels = {
    A : 2,
    B : 3,
    C : 4,
    D : 17
};

// export the required channels
for(var channelName in channels) {
    gpio.exportChannel(channels[channelName]);
}

// set all channels to GPIO output mode / direction
for(var channelName in channels) {
    gpio.assignDirection(channels[channelName], gpio.directions.out);
}

// API Part 1 : Read Status

// function to read status of the channels
var readStatusAction = function(callback) {
    var object = {};
    for(var channelName in channels) {
        var channel = channels[channelName];
        var value = gpio.readValue(channel);
        object[channelName] = ((value == 1) ? "high" : ((value == 0) ? "low" : "error"));
    }
    callback(object);
};

// API Part 2 : Set High / On

// function to set a channel as high
var setHighAction = function(channelName, callback) {
    var object = {};
    gpio.assignValue(channels[channelName], gpio.values.high);
    object[channelName] = 'high';
    callback(object);
};

// API Part 3 : Set Low / Off

// function to set a channel as low
var setLowAction = function(channelName, callback) {
    var object = {};
    gpio.assignValue(channels[channelName], gpio.values.low);
    object[channelName] = 'low';
    callback(object);
};

// API Part 4: Exit

// function to unexport all channels and close the server
var exitAction = function(callback) {
    gpio.unexportAllChannels();
    callback("Exit |->// ");
    server.close();
};

// API Key to access API
const apiKey = 'Z9FpluAnv';
console.log(apiKey);

// HTTP Web Server

// callback function to handle HTTP requests and pass responses
var handleReq = function(req, res) {
    console.log(req.url, "was requested");
    // path of the requested resource
    var uri = url.parse(req.url).pathname;
    // query string of the request
    var queryStr = url.parse(req.url).query || "";
    var query = queryStr.split("&");
    // store all GET parameters and arguments as an array
    var args = [];
    for(var i in query) {
        var parts = query[i].split("=");
        args[querystring.unescape(parts[0])] = querystring.unescape(parts[1]);
    }

    // test if the API key doesn't match prematurely terminates with 401
    if(args['key'] == undefined || args['key'] != apiKey) {
        res.writeHead(401, {"Content-Type": "text/plain"});
        res.end("401, Unathorised. You do not have permissions to access the API.");
        return;
    }

    // callback function that sends the queried data result as a json HTTP response
    var cb = function(object) {
        // in case rows is undefined or null prematurely terminate with 404
        if(object == null || object == undefined) {
            res.writeHead(404, {"Content-Type": "text/plain"});
            res.end("404, API Error. No such query.");
            return;
        }

        // data that is to be passed as JSON object in the HTTP response
        var data = {
            result: object
        };

        // pass the required HTTP response as a JSON
        res.writeHead(200, {"Content-Type": "application/json"});
        res.end(JSON.stringify(data));
    };

    if(uri == '/') {
        // display list of urls that allow switching as hypertext
        res.writeHead(200, {"Content-Type": "text/html"});
        res.end("<html>\n    <head>\n      <title>All Channel Switches</title>\n    </head>\n    <body>\n        <u>STATUS</u><br>\n        <a href=\"/api/readstatus?key=Z9FpluAnv\">/api/readstatus?key=Z9FpluAnv</a><br>\n\n        <u>SWITCH ON</u><br>\n        <a href=\"/api/sethigh?key=Z9FpluAnv&channel=A\">/api/sethigh?key=Z9FpluAnv&channel=A</a><br>\n        <a href=\"/api/sethigh?key=Z9FpluAnv&channel=B\">/api/sethigh?key=Z9FpluAnv&channel=B</a><br>\n        <a href=\"/api/sethigh?key=Z9FpluAnv&channel=C\">/api/sethigh?key=Z9FpluAnv&channel=C</a><br>\n        <a href=\"/api/sethigh?key=Z9FpluAnv&channel=D\">/api/sethigh?key=Z9FpluAnv&channel=D</a><br>\n\n        <u>SWITCH OFF</u><br>\n        <a href=\"/api/setlow?key=Z9FpluAnv&channel=A\">/api/setlow?key=Z9FpluAnv&channel=A</a><br>\n        <a href=\"/api/setlow?key=Z9FpluAnv&channel=B\">/api/setlow?key=Z9FpluAnv&channel=B</a><br>\n        <a href=\"/api/setlow?key=Z9FpluAnv&channel=C\">/api/setlow?key=Z9FpluAnv&channel=C</a><br>\n        <a href=\"/api/setlow?key=Z9FpluAnv&channel=D\">/api/setlow?key=Z9FpluAnv&channel=D</a><br>\n\n        <u>EXIT</u><br>\n        <a href=\"/api/exit?key=Z9FpluAnv\">/api/exit?key=Z9FpluAnv</a><br>\n    </body>\n</html>");
    }
    else if(uri == '/api/readstatus') {
        // call the appropriate API function to invoke callback function for part 1
        readStatusAction(cb);
    }
    else if(uri == '/api/sethigh') {
        var channelName = args['channel'];
        // call the appropriate API function to invoke callback function for part 2
        setHighAction(channelName, cb);
    }
    else if(uri == '/api/setlow') {
        var channelName = args['channel'];
        // call the appropriate API function to invoke callback function for part 3
        setLowAction(channelName, cb);
    }
    else if(uri == '/api/exit') {
        // call the appropriate API function to invoke callback function for part 4
        exitAction(cb);
    }
    else {
        res.writeHead(404, {"Content-Type": "text/plain"});
        res.end("404, API Error. No such resource.");
    }
};

// create an HTTP server with the required callback function
var server = http.createServer(handleReq);

// define the HTTP web server port
const port = 2017;

// start the web server
server.listen(port);
console.log("Web server started on http://localhost:" + port);
