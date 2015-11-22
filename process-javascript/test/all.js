var assert = require('assert');
var processJS = require('../process.js');

describe('processJS', function() {
    it('should work', function() {
        assert.equal(0, processJS.run('Name', '../test_data/'));
    });
});
