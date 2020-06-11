require 'rails_helper'

RSpec.describe Composteur, type: :model do
  subject { Composteur.new(name: "Hédas", address: "2 rue du hédas, Pau", category: "composteur de quartier") }

  before { subject.save }

  it 'should have a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'should only accept a name that is a string' do
    subject.name = 2
    expect(subject).to_not be_valid
  end

  it 'should have an address' do
    subject.address = nil
    expect(subject).to_not be_valid
  end

  it 'should have a category' do
    subject.category = nil
    expect(subject).to_not be_valid
  end

  it 'should accept only two types of category' do
    subject.category = "composteur de résidence privée"
    expect(subject).to_not be_valid
  end
end
