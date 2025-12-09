require 'rails_helper'

RSpec.describe User, type: :model do
  describe "moderator fields" do
    it "has is_moderator field defaulting to false" do
      user = User.create!(email: 'user@example.com', password: 'password123')
      expect(user.is_moderator).to be false
    end

    it "has is_admin field defaulting to false" do
      user = User.create!(email: 'user@example.com', password: 'password123')
      expect(user.is_admin).to be false
    end

    it "can create a moderator user" do
      moderator = User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true)
      expect(moderator.is_moderator).to be true
      expect(moderator.is_admin).to be false
    end

    it "can create an admin moderator user" do
      admin = User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true)
      expect(admin.is_moderator).to be true
      expect(admin.is_admin).to be true
    end
  end

  describe "#moderator?" do
    it "returns true for moderators" do
      moderator = User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true)
      expect(moderator.moderator?).to be true
    end

    it "returns false for regular users" do
      user = User.create!(email: 'user@example.com', password: 'password123')
      expect(user.moderator?).to be false
    end
  end

  describe "#admin?" do
    it "returns true for admins" do
      admin = User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true)
      expect(admin.admin?).to be true
    end

    it "returns false for non-admins" do
      user = User.create!(email: 'user@example.com', password: 'password123')
      expect(user.admin?).to be false
    end

    it "returns false for moderators without admin privilege" do
      moderator = User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true)
      expect(moderator.admin?).to be false
    end
  end

  describe "#can_delete_user?" do
    let(:regular_user) { User.create!(email: 'user@example.com', password: 'password123') }
    let(:moderator) { User.create!(email: 'mod@example.com', password: 'password123', is_moderator: true) }
    let(:admin_moderator) { User.create!(email: 'admin@example.com', password: 'password123', is_moderator: true, is_admin: true) }
    let(:target_user) { User.create!(email: 'target@example.com', password: 'password123') }
    let(:target_moderator) { User.create!(email: 'targetmod@example.com', password: 'password123', is_moderator: true) }

    context "when user is not a moderator" do
      it "cannot delete any user" do
        expect(regular_user.can_delete_user?(target_user)).to be false
      end
    end

    context "when user is a moderator without admin privilege" do
      it "can delete regular users" do
        expect(moderator.can_delete_user?(target_user)).to be true
      end

      it "cannot delete other moderators" do
        expect(moderator.can_delete_user?(target_moderator)).to be false
      end

      it "cannot delete admin moderators" do
        expect(moderator.can_delete_user?(admin_moderator)).to be false
      end
    end

    context "when user is an admin moderator" do
      it "can delete regular users" do
        expect(admin_moderator.can_delete_user?(target_user)).to be true
      end

      it "can delete other moderators" do
        expect(admin_moderator.can_delete_user?(target_moderator)).to be true
      end

      it "can delete other admin moderators" do
        another_admin = User.create!(email: 'admin2@example.com', password: 'password123', is_moderator: true, is_admin: true)
        expect(admin_moderator.can_delete_user?(another_admin)).to be true
      end
    end
  end
end
