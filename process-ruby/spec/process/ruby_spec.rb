require 'spec_helper'

describe Process::Ruby do

  it 'does something useful' do
    expect(Process.process("Name", "../test_data/")).to eq(true)
  end
end
