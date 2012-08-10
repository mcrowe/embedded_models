require 'spec_helper'

describe EmbeddedModels::Base do

  with_model :Account do
    table do |t|
      t.integer :feature_limit
      t.integer :feature_bonus
    end

    model do
      embeds :feature
    end
  end

  class Feature
  end

  it 'adds a "embeds" method to active record models' do
    Account.should respond_to(:embeds)
  end

  describe '.embeds' do
    it 'defines a method to access the embedded model' do
      account = Account.new(:feature_limit => 1, :feature_bonus => 2)
      account.should respond_to(:feature)
    end
  end

  describe '#[embedded_model_name]' do
    it 'returns the embedded model' do
      account = Account.new(:feature_limit => 1, :feature_bonus => 2)
      account.feature.should be_a(Feature)
    end
  end

end