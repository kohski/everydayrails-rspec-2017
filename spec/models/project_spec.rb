require 'rails_helper'

RSpec.describe Project, type: :model do
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    user.projects.create(
      name:"Test Project"
    )

    new_project = user.projects.new(
      name:"Test Project"
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  it "allows two user to share a project name" do
    user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
    
    user.projects.create(
      name:"Test Project"
    )

    other_user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester2@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )

    other_project = other_user.projects.new(
      name:"Test Project"
    )
    expect(other_project).to be_valid
  end

  describe "late status" do
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    it "is on time when tu due date is today" do
      project = FactoryBot.create(:project, :project_due_today)
      expect(project).to_not be_late
    end

    it "is on time when tu due date is in the future" do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end
  end

  describe "number of notes" do
    it "can have many notes" do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end
  end

  # pending "add some examples to (or delete) #{__FILE__}"
end
