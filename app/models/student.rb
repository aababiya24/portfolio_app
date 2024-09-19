class Student < ApplicationRecord

    validates :first_name, presence:true
    validates :last_name, presence:true
    validates :school_email, presence:true, uniqueness:true
    validates :major, presence:true
    # validates :expected_graduation_date, presence true

end
