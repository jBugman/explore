var fs = require('fs');
var path = require('path');
var csv = require('csv-stringify');
var streamify = require('stream-array');

exports.run = function(field, folder) {
    var frequencies = new Map();
    var files = fs.readdirSync(folder);
    for (var i in files) {
        var file = files[i];
        if (!(file.endsWith('.json'))) {
            continue;
        }
        var data = JSON.parse(fs.readFileSync(path.join(folder, file)));
        if (!(field in data)) {
            console.error('Field is missing');
            return 1;
        }
        var value = data[field];
        if (typeof(value) != 'string') {
            console.error('Field is not a string');
            return 1;
        }
        if (value != '') {
            frequencies.set(value, (frequencies.get(value) || 0) + 1);
        }
    }
    var sorted = Array.from(frequencies).sort(function(a, b) {
        return b[1] - a[1];
    });
    var output = fs.createWriteStream('output.csv');
    streamify(sorted).pipe(csv()).pipe(output);
    return 0;
};
