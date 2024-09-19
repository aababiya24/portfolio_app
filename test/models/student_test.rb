require "test_helper"

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test"should raise error when saving student without first name" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name:"Ali", last_name:"Bira", school_email:"abira@msudenver.edu", major:"CS")
    end
  end



end
