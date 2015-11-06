require "process"

describe("process", function()
  it("should work", function()
    assert.has_no.errors(function() process("Name", "../test_data/") end)
  end)
end)
