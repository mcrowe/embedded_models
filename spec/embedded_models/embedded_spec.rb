require 'spec_helper'

describe EmbeddedModels::Embedded do

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
    include EmbeddedModels::Embedded
  end

  before do
    @account = Account.new(:feature_limit => 1, :feature_bonus => 2)
    @feature = @account.feature
  end

  describe '#attributes' do
    it 'returns all attributes of the composite that begin with the prefix' do
      @feature.attributes.should == {
        'limit' => 1,
        'bonus' => 2
      }
    end
  end

  describe '#update_attributes' do

    it 'is false if given an invalid attribute' do
      @feature.update_attributes(:nothing => 2).should be_false
    end

    it 'is true if successful' do
      @feature.update_attributes(:limit => 3).should be_true
    end

    it 'updates the appropriate attributes of the composite' do
      @feature.update_attributes(:limit => 3, :bonus => 4)

      @account.feature_limit.should == 3
      @account.feature_bonus.should == 4
    end
  end

  describe '#[attribute]' do
    it 'returns the value of the attribute' do
      @feature.limit.should == 1
    end
  end

  describe '#[attribute]=' do
    it 'returns the value of the attribute' do
      @feature.limit = 2
      @feature.attributes[:limit].should == 2
      @feature.limit.should == 2
    end
  end

  describe 'save' do
    it 'persists any changes to the attributes' do
      @feature.limit = 2
      @feature.save
      @account.reload.feature_limit.should == 2
    end
  end

end