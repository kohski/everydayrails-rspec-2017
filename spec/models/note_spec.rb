require 'rails_helper'

RSpec.describe Note, type: :model do
  before do
    @user = User.create(
      first_name: "Joe",
      last_name: "Tester",
      email: "joetester@example.com",
      password: "dottle-nouveau-pavilion-tights-furze",
    )
    @project = @user.projects.create(
      name:"Test Project",
    )
  end

  it "generates associated data from a factory" do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end

  #validatorのテスト
  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note",
      user: @user,
      project: @project,
    )
    expect(note).to be_valid
  end

  it "is invalid without a message " do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")    
  end


  # 文字列に一致するメッセージを検索
  describe "search message for a term" do
    before do
      note1 = @project.notes.create(
        message: "This is the first note",
        user: @user
      )
      note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user,
      )
      note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user,
      )
    end

    #一致するデータが見つかるとき
    context "when match is found" do
    
    end
    # 一致するデータが見つからないとき
    context "when no match is found" do
      it "returns an empty collection when no results are found" do    
        expect(Note.search("message")).to be_empty
      end
    end
  end

  # pending "add some examples to (or delete) #{__FILE__}"
end
