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
    And Существуют следующие города
      | name         |
      | Kaliningrad  |
      | Chernyahovsk |
    And Существуют следующие улицы
      | city_name    | name     |
      | Kaliningrad  | Leonova  |
      | Kaliningrad  | Krasnaya |
      | Chernyahovsk | Mira     |
      | Chernyahovsk | Ushakova |
#    And Существуют следующие районы
#      | name    |
#      | Center  |
#      | Western |
#      | Eastern |
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
    And Существует следующий адрес для филиала "TestCompany branch0" компании "TestCompany"
      | city_name   | district_name | street_name | house | office | cabinet |
      | Kaliningrad | Western       | Krasnaya    | 34    | 5      |         |
    And Существует следующий адрес для филиала "EastCompany branch 2" компании "EastCompany"
      | city_name    | district_name | street_name | house | office | cabinet |
      | Chernyahovsk | Center        | Ushakova    | 21    |        | 3       |
    And Для филиала "EastCompany branch 1" компании "EastCompany" существуют телефоны
      | contact | director | fax  | mobile | mobile_refix | name   | order_num | publishable |
      | true    | true     | true | false  |              | 123456 | 1         | true        |
    And Для филиала "TestCompany branch0" компании "TestCompany" существуют телефоны
      | contact | director | fax   | mobile | mobile_refix | name    | order_num | publishable |
      | true    | false    | false | true   | 921          | 7987654 | 1         | false       |
      | true    | true     | true  | false  |              | 123222  | 1         | true        |

  @javascript
  Scenario: Пользователь может искать компанию по всем возможным параметрам
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "est" в поле "search_name"
    And Я ввожу "test_branch0@test.com" в поле "search_email"
    And Я выбираю "Kaliningrad" из элемента "select_search_city"
#    And Я выбираю "Western" из элемента "select_search_district"
    And Я выбираю "Krasnaya (Kaliningrad)" из элемента "select_search_street"
    And Я ввожу "34" в поле "search_house"
    And Я ввожу "5" в поле "search_office"
    And Я ввожу "123" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу таблицу "search_results_table" с компаниями
      | status  | title       |
      | Активна | TestCompany |

  @javascript
  Scenario: Пользователь не может найти компанию разным критериям с условием "И"
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    And Я нахожусь на странице "Поиск"
    When Я ввожу "est" в поле "search_name"
    And Я ввожу "test_branch1@test.com" в поле "search_email"
    And Я выбираю "Chernyahovsk" из элемента "select_search_city"
#    And Я выбираю "Western" из элемента "select_search_district"
    And Я выбираю "Ushakova (Chernyahovsk)" из элемента "select_search_street"
    And Я ввожу "3" в поле "search_cabinet"
    And Я ввожу "1234" в поле "search_phone"
    And Я нажимаю на кнопку "do_search"
    Then Я вижу сообщение "Ничего не найдено"

  @javascript
  Scenario: Пользователь не может начать поиск до тех пор, пока не заполнено хотя бы одно поле для ввода параметра.
    Given Я авторизован в системе
    And Я перехожу на страницу "Поиск"
    When Я нахожусь на странице "Поиск"
    Then Кнопка "do_search" - "не активна"
    When Я ввожу "test" в поле "search_name"
    Then Кнопка "do_search" - "активна"