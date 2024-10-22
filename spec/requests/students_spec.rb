require 'rails_helper'

# Request specs for the Students resource focusing on HTTP requests
RSpec.describe "Students", type: :request do

  # GET /students (index)
  describe "GET /students" do
    context "when students exist" do
      let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

      # Test 1: Returns a successful response and displays the search form
      it "returns a successful response and displays the search form" do
        get students_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Search') # Ensure search form is rendered
      end

      # Test 2: Ensure it does NOT display students without a search
      it "does not display students until a search is performed" do
        get students_path
        expect(response.body).to_not include("Aaron")
      end
    end

    # Test 3: Handle missing records or no search criteria provided
    context "when no students exist or no search is performed" do
      it "displays a message prompting to search" do
        get students_path
        expect(response.body).to include("Please enter search criteria to find students")
      end
    end
  end

  # Search functionality
  describe "GET /students (search functionality)" do
    let!(:student1) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }
    let!(:student2) { Student.create!(first_name: "Jackie", last_name: "Joyner", school_email: "joyner@msudenver.edu", major: "Data Science and Machine Learning Major", expected_graduation_date: "2026-05-15") }

    # Test 4: Search by major
    it "returns students matching the major" do
      get students_path, params: { search: { major: "Computer Science BS" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 5: Search by expected graduation date (before)
    it "returns students graduating before the given date" do
      get students_path, params: { search: { expected_graduation_date: "2026-01-01", date_condition: "before" } }
      expect(response.body).to include("Aaron")
      expect(response.body).to_not include("Jackie")
    end

    # Test 6: Search by expected graduation date (after)
    it "returns students graduating after the given date" do
      get students_path, params: { search: { expected_graduation_date: "2025-12-31", date_condition: "after" } }
      expect(response.body).to_not include("Aaron")
      expect(response.body).to include("Jackie")
    end
  end

  # POST /students (create)
  describe "POST /students" do
    context "with valid parameters" do
      # Test 7: Create a new student and ensure it redirects
      it "creates a new student and redirects" do
        expect {
          post students_path, params: { student: { first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15" } }
        }.to change(Student, :count).by(1)

        expect(response).to have_http_status(:found)  # Expect redirect after creation
        follow_redirect!
        expect(response.body).to include("Aaron")  # Student's details in the response
      end

      # Test 8: Ensure that it returns a 201 status or check for creation success
      it "returns a 201 status on successful creation" do
        post students_path, params: { student: { first_name: "New", last_name: "Student", school_email: "newstudent@msudenver.edu", major: "Biology", expected_graduation_date: "2027-05-15" } }
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      # Test 9: Ensure it does not create a student and returns a 422 status
      it "does not create a student and returns a 422 status for invalid parameters" do
        post students_path, params: { student: { first_name: "", last_name: "", school_email: "invalidemail", major: "", expected_graduation_date: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # GET /students/:id (show)
  describe "GET /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

    # Test 10: Fetching a student details successfully
    it "returns a 200 OK status when fetching an existing student's details" do
      get student_path(student)
      expect(response).to have_http_status(:ok)
    end

    # Test 11: Correct student details in response
    it "includes the student's details in the response body" do
      get student_path(student)
      expect(response.body).to include(student.first_name)
      expect(response.body).to include(student.last_name)
    end

    # Test 12: Returns a 404 when trying to fetch a non-existent student
    it "returns a 404 status when trying to fetch a non-existent student" do
      get "/students/9999"
      expect(response).to have_http_status(:not_found)
    end
  end

  # DELETE /students/:id (destroy)
  describe "DELETE /students/:id" do
    let!(:student) { Student.create!(first_name: "Aaron", last_name: "Gordon", school_email: "gordon@msudenver.edu", major: "Computer Science BS", expected_graduation_date: "2025-05-15") }

    # Test 13: Deleting a student and redirecting
    it "deletes the student and redirects to the index page" do
      delete student_path(student)
      expect(response).to redirect_to(students_path)
      follow_redirect!
      expect(response.body).not_to include("Aaron Gordon")
    end

    # Test 14: Returns a 404 when trying to delete a non-existent student
    it "returns a 404 status when trying to delete a non-existent student" do
      delete "/students/9999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
