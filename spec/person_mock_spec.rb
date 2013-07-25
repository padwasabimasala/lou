require 'spec_helper'

describe PersonMock do
  it "can chain ActiveRecord query methods" do
    PersonMock.all.joins(:any).where(:any).where(:more).limit(10).order(:id).should be PersonMock
  end
end

