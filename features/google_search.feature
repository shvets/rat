Feature: Using Google

  Scenario: Searching for a term without submit

    Given I am on google.com
    When I enter "Capybara"
    Then I should see css "div#res li"

  @selenium
  Scenario: Searching with selenium for a term with submit

    Given I am on google.com
    When I enter "Capybara"
    And click submit button
    Then I should see results: "Capybara"

  @webkit
  Scenario: Searching with webkit for a term with submit

    Given I am on google.com
    When I enter "Capybara"
    And click submit button
    Then I should see results: "Capybara"