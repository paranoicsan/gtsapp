Feature: Должна быть возможность для поиска компаний, зарегистрированных в системе, по всем видам названий.
  Как пользователь, я хочу иметь возожность быстро найти нужную мне компанию, зная только одно из её названий -
  либо фактическое, либо юридическое. Есть ещё самостоятельное название у самого объекта компании.

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
      | form_type | fact_name            | legel_name        |
      | ООО       | TestCompany branch0  | TestCompany legel |
    And Существуют следующие филиалы для компании "EastCompany"
      | form_type | fact_name            | legel_name          |
      | ООО       | EastCompany branch   | EastCompany legel 1 |
      | МУП       | EastCompany branch   | EastCompany legel 2 |

  @javascript
  Scenario: Пользователь может искать компанию по прямому названию
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "est" в поле "search_name"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |
      | Активна | WestCompany |

  @javascript
  Scenario: Пользователь может искать компанию по фактическому названию филиала
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "bran" в поле "search_name"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |
      | Активна | EastCompany |

  @javascript
  Scenario: Пользователь может искать компанию по юридическому названию филиала
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "legel" в поле "search_name"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |
      | Активна | EastCompany |
