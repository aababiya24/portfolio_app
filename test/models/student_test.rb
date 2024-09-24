require "test_helper"

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test"should raise error when saving student without first name" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(first_name:"Ali")
    end
  end

  test"should raise error when saving student without last name" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(last_name:"Bira")
    end
  end

  test"should raise error when saving student without major" do
    assert_raises ActiveRecord::RecordInvalid do
      Student.create!(major:"CS")
    end
  end


  test 'should raise error when saving school email with invalid format' do
    # Invalid emails list
    invalid_emails = ['user','user@','user@com','@gmail.com','name@msudenver.com', 'name.doe@msudenver.edu.edu']

    invalid_emails.each do |email|
      student = Student.new(school_email: email)
      assert_not student.valid?
      assert_includes student.errors[:school_email], 'must be a valid email address'
    end
  end


  test "should raise error when saving student without expected date" do
    assert_raises ActiveRecord::RecordInvalid do
    # expected date should be a year from today
      Student.create!(expected_graduation_date: Date.today + 1.year)
    end
  end

end
