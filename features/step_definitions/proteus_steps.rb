When /^I go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then(/^I should be on Plan Setup page$/) do
  page.should have_content 'Select one of our most popular plans'
end

When(/^I select Plan$/) do
  find('.first.plan_column .plan:first-child a.save').click
end

When(/^I select Phone Adapter$/) do
  device_selector = '.equipment.section .adapter:first-child input[type=radio]'

  page.has_selector? device_selector, :visible => true # wait for ajax to be finished

  find(device_selector).click
end

Then(/^I should see phone adapter message$/) do
  page.should have_content 'Transfer your phone number or get a new one'
end

When(/^I pick a new phone number$/) do
  find('input[value=new_did]').click

  select 'New Jersey', from: 'did_request[state_code]'
  select '732', from: 'did_request[npa]'

  select 'Red Bank 732-678-xxxx', from: 'did_request[nxx]'
  select '732-678-1231', from: 'did_request[selected_number]'
end

When(/^I click "Continue"$/) do
  find('.back_fwd_btns .next a').click
end

Then(/^I should be on Contact Information Page$/) do
  page.should have_content "Enter your contact information"
end
