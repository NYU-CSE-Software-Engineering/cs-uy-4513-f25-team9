# features/step_definitions/user_moderation_steps.rb
Given("there is a reported user with ID {string}, name {string} and report reason {string}") do |user_id, name, reason|
    # Create reported user
    @reported_user = User.create!(
      id: user_id,
      name: name,
      email: "user#{user_id}@example.com",
      password: 'password123',
      status: 'active'
    )
    
    # Create reporter
    @reporter = User.create!(
      email: "reporter#{user_id}@example.com",
      password: 'password123',
      name: "Reporter #{user_id}"
    )
    
    # Create report record
    UserReport.create!(
      reported_user: @reported_user,
      reporter: @reporter,
      reason: reason,
      status: 'unprocessed'
    )
  end
  
  Given("I am on the reported users page") do
    visit moderations_reported_users_path
  end
  
  When("I submit a ban request for user ID {string} with reason {string} and permanent ban selected") do |user_id, reason|
    within("tr:has(td:contains('#{User.find(user_id).name}'))") do
      fill_in 'ban_reason', with: reason
      check 'is_permanent'
      click_button 'Ban User'
    end
  end
  
  Then("the user with ID {string} should be marked as banned in the database") do |user_id|
    user = User.find(user_id)
    expect(user.status).to eq('banned')
  end
  
  Then("a moderation log for user ban should be created") do
    expect(ModerationLog.where(operation_type: 'user_ban', target_user: @reported_user).exists?).to be true
  end
  
  When("I submit a ban request for user ID {string} with reason {string} and {int} days duration") do |user_id, reason, days|
    within("tr:has(td:contains('#{User.find(user_id).name}'))") do
      fill_in 'ban_reason', with: reason
      fill_in 'ban_duration', with: days
      uncheck 'is_permanent'
      click_button 'Ban User'
    end
  end
  
  Then("the user with ID {string} should have a banned_until date {int} days from now") do |user_id, days|
    user = User.find(user_id)
    expected_date = days.days.from_now.to_date
    expect(user.banned_until.to_date).to eq(expected_date)
  end