require 'rails_helper'

RSpec.describe User, type: :model do

  subject { @user = User.new(username: "a"*3, email: "test@example.com", 
           password: "password", password_confirmation: "password") }

  context "on user create" do
    it "cannot have a blank username" do
      user = User.new(username: nil)
      expect(user).not_to be_valid
    end
    it "cannot have a username shorter than 3 chars" do
      user = User.new(username: "aa")
      expect(user).not_to be_valid
    end
    it "cannot have a blank email" do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end
    it "cannot have an invalid email" do
      user = User.new(email: "foo@bar")
      expect(user).not_to be_valid
    end
    it "cannot have a blank password" do
      user = User.new(password: nil)
      expect(user).not_to be_valid
    end
    it "saves with valid attributes" do
      should be_valid
    end
    it "cannot have a duplicate email" do
      user = subject.dup
      user.username = "b"*3
      subject.save
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "cannot have a duplicate username" do
      user = subject.dup
      user.email = "test2@example.com"
      subject.save
      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
