require 'spec_helper'

describe RecordsController do

  describe "Delete destroy" do
    it "delete the record" do
      record = Fabricate(:record)
      delete :destroy, id: record, month_from_now: 2
      Record.not_delete.size.should == 0
    end
    it "ask whether to delte the period record"
  end

end