Feature: Должна быть возможность для поиска компаний, зарегистрированных в системе, по телефонным номерам.
  Как пользователь, я хочу иметь возожность быстро найти нужную мне компанию, зная только её телефонный номер.

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
    And Для филиала "EastCompany branch" компании "EastCompany" существуют телефоны
      | contact | director | fax  | mobile | mobile_refix | name   | order_num | publishable |
      | true    | true     | true | false  |              | 123456 | 1         | true        |
    And Для филиала "TestCompany branch0" компании "TestCompany" существуют телефоны
      | contact | director | fax   | mobile | mobile_refix | name    | order_num | publishable |
      | true    | false    | false | true   | 921          | 7987654 | 1         | false       |
      | true    | true     | true  | false  |              | 123222  | 1         | true        |

  @javascript
  Scenario: Пользователь может искать компанию по городскому номеру телефона
    Given Я авторизован в системе
    And Я нажимаю на ссылку "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "1234" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
    And Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | EastCompany |
    And Я ввожу "123" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | EastCompany |
      | Активна | TestCompany |

  @javascript
  Scenario: Пользователь может искать компанию по мобильному номеру телефона
    Given Я авторизован в системе
    And Я нажимаю на ссылку "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "79" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |