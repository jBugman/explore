#!/usr/bin/env node
var processJS = require('./process.js');

if (process.argv.length == 4) {
    processJS.run(process.argv[2], process.argv[3]);
} else {
    console.log('Args are: <field name> <folder>');
}

// // Benchmark
// for(var i = 0; i < 100; i++) {
//     processJS.run('Name', '../test_data/');
// }
