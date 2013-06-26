# language: ru

Функционал: Используем Гугл

  Сценарий: Поиск без посылки формы
    Дано I am on google.com
    Когда I enter "Capybara"
    Тогда I should see css "div#res li"

  @selenium
  Сценарий: Searching with selenium for a term with submit

    Дано I am on google.com
    Когда I enter "Capybara"
    И click submit button
    Тогда I should see results: "Capybara"

  @webkit
  Сценарий: Searching with webkit for a term with submit

    Дано I am on google.com
    Когда I enter "Capybara"
    И click submit button
    Тогда I should see results: "Capybara"