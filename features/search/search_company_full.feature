Feature: Должна быть возможность для поиска компаний, зарегистрированных в системе.
  При этом, если пользователь заполнил несколько полей, т.е. хочет искать по нескольким параметрам,
  необходимо сужать найденные результаты - показывать компании, которые удовлетворяют полностью всем
  критериям поиска.

  Background:
    Given Существуют следующие компании
      | title         |
      | TestCompany   |
      | EastCompany   |
      | WestCompany   |
    And Существуют следующие формы собственности
      | name |
      | ООО  |
      | МУП  |
    And Существуют следующие филиалы для компании "TestCompany"
      | form_type | fact_name             | legel_name        |
      | ООО       | TestCompany branch0   | TestCompany legel |
    And Существуют следующие филиалы для компании "EastCompany"
      | form_type | fact_name             | legel_name          |
      | ООО       | EastCompany branch 1  | EastCompany legel 1 |
      | МУП       | EastCompany branch 2  | EastCompany legel 2 |
    And Существуют следующие адреса электронной почты для филиала "TestCompany branch0" компании "TestCompany"
      | name                    |
      | test_branch0@test.com   |
      | test_branch0_1@test.com |
    And Существуют следующие адреса электронной почты для филиала "EastCompany branch 1" компании "EastCompany"
      | name                    |
      | test_branch1@test.com   |
      | test_branch1_1@test.com |

  @javascript
  Scenario: Пользователь может искать компанию по одному из названий и электронной почте
    Given Я авторизован в системе
    And Я нажимаю на ссылку "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "est" в поле "search_name"
    And Я ввожу "test_branch0@test.com" в поле "search_email"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |

  @javascript
  Scenario: Пользователь не может найти компанию разным критериям с условием "И"
    Given Я авторизован в системе
    And Я нажимаю на ссылку "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "est" в поле "search_name"
    And Я ввожу "test_branch1@test.com" в поле "search_email"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу сообщение "Ничего не найдено"

