Feature: К филиалу может быть привязано множество веб-сайтов.
  Как пользователь, я хочу иметь возможность добавлять сайты к филиалам.

  Background:
    Given Существуют следующие компании
      | title         |
      | Рога и копыта |
    And Существуют следующие филиалы для компании "Рога и копыта"
      | fact_name      | legel_name              |
      | Филиал рогов   | Юр. имя филиала рогов   |
    And Существуют следующие пользователи
      | username   | password | email               | roles    |
      | t_admin    | 1111     | t_admin@test.com    | admin    |
      | t_operator | 1111     | t_operator@test.com | operator |
      | t_agent    | 1111     | t_agent@test.com    | agent    |

  # TODO: Потом надо изменять, чтобы разделить на возможность отложенного добавления
  # веб-сайтов к филиалу
  @javascript
  Scenario: Пользователь может добавить несколько веб-сайтов к филиалу
    Given Я авторизован в системе
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    And Кнопка "branch_add_website" - "не активна"
    And Я вижу надпись "Нет данных"
    When Я ввожу "http://wwww.example.com" в поле "branch_website"
    And Я нажимаю на кнопку "branch_add_website"
    And Я ввожу "http://wwww.example2.com" в поле "branch_website"
    And Кнопка "branch_add_website" - "активна"
    And Я нажимаю на кнопку "branch_add_website"
    And Я вижу таблицу "websites" с веб-сайтами
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |

  Scenario: Один и тот же веб-сайт нельзя добавить в систему дважды

  Scenario: Администратор может удалить веб-сайт из филиала

  Scenario: Пользователь не может удалить веб-сайт из филиала
    Given Я - пользователь "t_agent" с паролем "1111"
    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    Then Я не вижу ссылки "Удалить" в таблице "websites"

  Scenario: Оператор может удалить веб-сайт из филиала
#    Given Я авторизован в системе
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |
#
#    And Кнопка "branch_add_website" - "не активна"
#    And Я вижу надпись "Нет данных"
#    When Я ввожу "http://wwww.example.com" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    And Я ввожу "http://wwww.example2.com" в поле "branch_website"
#    And Кнопка "branch_add_website" - "активна"
#    And Я нажимаю на кнопку "branch_add_website"
#    And Я вижу таблицу "websites" с веб-сайтами
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |