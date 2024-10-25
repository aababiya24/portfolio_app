class Student < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    # adding image
    has_one_attached :profile_picture, dependent: :purge_later

    validates :first_name, presence:true
    validates :last_name, presence:true

    validate :email_format
    def email_format
        unless email =~ /\A[\w+\-.]+@msudenver\.edu\z/i
            errors.add(:email, "must be an @msudenver.edu email address")
        end
    end
 

    validates :major, presence:true
    validates :expected_graduation_date, presence: true


    VALID_MAJORS =  ["Computer Engineering BS", "Computer Information Systems BS",
    "Computer Science BS", "Cybersecurity Major", "Data Science and Machine Learning Major"]

    validates :major, inclusion: { in: VALID_MAJORS, message: "%{value} is not a valid major" }



end
