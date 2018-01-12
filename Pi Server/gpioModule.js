// import the required modules
var fs = require('fs');

// define the different actions for GPIO
exports.path = '/sys/class/gpio';
exports.actionsPath = {
    // used to export a channel
    export: exports.path + '/export',
    // used to unexport a channel
    unexport: exports.path + '/unexport',
    // used to assign/read a direction to/from a channel
    direction: (channel) => {
        // channel whose direction is to be changed/read
        return exports.path + '/gpio' + channel + '/direction';
    },
    // used to assign/read a value to/from a channel
    value: (channel) => {
        // channel whose value is to be changed/read
        return exports.path + '/gpio' + channel + '/value';
    }
};

// defines the directions for GPIO
exports.directions = {
    out: "out",
    in: "in"
};
exports.values = {
    high: 1,
    low: 0
};

// keeps a track of exported channels
exports.exportedChannels = [];

// function to export a channel
exports.exportChannel = (channel) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(exports.exportedChannels.includes(channel)) throw new Error("This channel is already exported.");

    // use the file system to export a specific channel
    fs.writeFileSync(exports.actionsPath.export, new Number(channel).toString(), 'ascii');
    // add the channel number to exported list
    exports.exportedChannels.push(channel);
};

// function to unexport a channel
exports.unexportChannel = (channel) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(!exports.exportedChannels.includes(channel)) throw new Error("This channel is not exported. Hence, unavailable for unexport.");

    // use the file system to unexport a specific channel
    fs.writeFileSync(exports.actionsPath.unexport, new Number(channel).toString(), 'ascii');
    // remove the channel number from the exported list
    exports.exportedChannels = exports.exportedChannels.slice(0, exports.exportedChannels.indexOf(channel)).concat(exports.exportedChannels.slice(exports.exportedChannels.indexOf(channel) + 1, exports.exportedChannels.length));
};

// function to assign direction to a channel
exports.assignDirection = (channel, direction) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(!(direction === exports.directions.in || direction === exports.directions.out)) throw new Error("Direction variable should be either out or in. Found " + direction + ".");
    if(!exports.exportedChannels.includes(channel)) throw new Error("This channel is not exported. Please export the channel before assigning any direction to it.");

    // use the file system to assign a direction to specific channel
    if(direction === exports.directions.in) {
        // assign direction as input
        fs.writeFileSync(exports.actionsPath.direction(channel), exports.directions.in, 'ascii');
    }
    else if(direction === exports.directions.out) {
        // assign direction as output
        fs.writeFileSync(exports.actionsPath.direction(channel), exports.directions.out, 'ascii');
    }
};

// function to read direction from a channel
exports.readDirection = (channel) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(!exports.exportedChannels.includes(channel)) throw new Error("This channel is not exported. Please export the channel before reading any direction from it.");

    // use the file system to read a direction from a specific channel
    var direction = fs.readFileSync(exports.actionsPath.direction(channel), 'ascii').toString('ascii').trim();
    if(direction === exports.directions.in) {
        // reads direction as input
        return exports.directions.in;
    }
    else if(direction === exports.directions.out) {
        // reads direction as output
        return exports.directions.out;
    }
    else {
        throw new Error("Unable to read assigned direction from the channel.");
    }
};

// function to assign high/low value to an output channel
exports.assignValue = (channel, value) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(!(value === exports.values.low || value === exports.values.high)) throw new Error("Value variable should be either 0 or 1. Found " + value + ".");
    if(!exports.exportedChannels.includes(channel)) throw new Error("This channel is not exported. Please export the channel before assigning any value to it.");
    if(!(exports.readDirection(channel) === exports.directions.out)) throw new Error("This channel does not have out direction. Hence, values cannot be assigned to it. Please assign direction out before setting a value.");

    // use the file system to write a value to a specific channel
    if(value === exports.values.high) {
        // writes high value to channel
        fs.writeFileSync(exports.actionsPath.value(channel), new Number(exports.values.high).toString(), 'ascii');
    }
    else if(value === exports.values.low) {
        // writes low value to channel
        fs.writeFileSync(exports.actionsPath.value(channel), new Number(exports.values.low).toString(), 'ascii');
    }
};

// function to read high/low value from a channel
exports.readValue = (channel) => {
    // error handling
    if(typeof channel != 'number') throw new TypeError("Channel variable must be of type number. Found " + typeof channel + ".");
    if(!exports.exportedChannels.includes(channel)) throw new Error("This channel is not exported. Please export the channel before reading any value from it.");

    // use the file system to read the value of a specific channel
    var value = fs.readFileSync(exports.actionsPath.value(channel), 'ascii').toString('ascii').trim();
    if(value === new Number(exports.values.low).toString()) {
        // reads value as low
        return exports.values.low;
    }
    else if(value === new Number(exports.values.high).toString()) {
        // read value as high
        return exports.values.high;
    }
    else {
        throw new Error("Unable to read value from the channel.");
    }
};

// function to unexport all channels
exports.unexportAllChannels = () => {
    // unexports channels till exported channels count comes to zero
    while(exports.exportedChannels.length !== 0) {
        exports.unexportChannel(exports.exportedChannels[0]);
    }
}
