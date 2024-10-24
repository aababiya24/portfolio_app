class Student < ApplicationRecord

    # adding image
    has_one_attached :profile_picture, dependent: :purge_later

    validates :first_name, presence:true
    validates :last_name, presence:true
    # added regular expression to check email follows format
    validates :school_email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+(?:\.[\w+\-.]+)*@msudenver\.edu\z/i, message: 'must be a valid email address' }
    validates :major, presence:true
    validates :expected_graduation_date, presence: true


    VALID_MAJORS =  ["Computer Engineering BS", "Computer Information Systems BS",
    "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    validates :major, inclusion: { in: VALID_MAJORS, message: "%{value} is not a valid major" }



end
