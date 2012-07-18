Feature: К филиалу может быть привязано множество адресов электронной почты.
  Как пользователь, я хочу иметь возможность добавлять email к филиалам.

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

  @javascript
  @focus
  Scenario: Пользователь может добавить несколько email к филиалу
    Given Я авторизован в системе
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    And Кнопка "branch_add_email" - "не активна"
    And Я вижу надпись "Нет данных"
    When Я ввожу "test@test.com" в поле "branch_email"
    And Я нажимаю на кнопку "branch_add_email"
    And Я ввожу "test2@test.com" в поле "branch_email"
    And Кнопка "branch_add_email" - "активна"
    And Я нажимаю на кнопку "branch_add_email"
    And Я вижу таблицу "emails" с адресами
      | name           |
      | test@test.com  |
      | test2@test.com |

#
#  @javascript
#  Scenario: Один и тот же веб-сайт нельзя добавить в систему дважды
#    Given Я - пользователь "t_admin" с паролем "1111"
#    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я ввожу "http://wwww.example.com" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    Then Я вижу сообщение "Такой веб-сайт уже существует!"
#
#  @javascript
#  Scenario: Администратор может удалить веб-сайт из филиала
#    Given Я - пользователь "t_admin" с паролем "1111"
#    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я удаляю веб-сайт "http://wwww.example.com" из филиала "Филиал рогов"
#    Then Я вижу таблицу "websites" с веб-сайтами
#      | name                    |
#      | http://wwww.example2.com |
#
#  @javascript
#  Scenario: Пользователь латиницей может ввести адрес только в формате "http://www.example.com"
#    Given Я авторизован в системе
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я ввожу "www.example.com" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    Then Я вижу сообщение "Формат: http://www.example.com и ВашСайт.рф."
#    And Я ввожу "http://example.m" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    And Я вижу сообщение "Формат: http://www.example.com и ВашСайт.рф."
#    And Я ввожу "example.com" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    And Я вижу сообщение "Формат: http://www.example.com и ВашСайт.рф."
#
#  @javascript
#  Scenario: Пользователь может вводить адрес веб-сайта на русском языке
#    Given Я авторизован в системе
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я ввожу "россия.рф" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    Then Я вижу таблицу "websites" с веб-сайтами
#      | name      |
#      | россия.рф |
#
#  @javascript
#  Scenario: Пользователь кириллицией может ввести адрес только в формате "вашсайт.рф"
#    Given Я авторизован в системе
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я ввожу "россиярф" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    Then Я вижу сообщение "Формат: http://www.example.com и ВашСайт.рф."
#    And Я ввожу "www.россия.рф" в поле "branch_website"
#    And Я нажимаю на кнопку "branch_add_website"
#    Then Я вижу сообщение "Формат: http://www.example.com и ВашСайт.рф."
#
#  Scenario: Пользователь не может удалить веб-сайт из филиала
#    Given Я - пользователь "t_agent" с паролем "1111"
#    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |
#    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    Then Я не вижу ссылки "Удалить" в таблице "websites"
#
#  @javascript
#  Scenario: Оператор может удалить веб-сайт из филиала
#    Given Я - пользователь "t_operator" с паролем "1111"
#    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
#      | name                    |
#      | http://wwww.example.com |
#      | http://wwww.example2.com |
#    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
#    When Я удаляю веб-сайт "http://wwww.example.com" из филиала "Филиал рогов"
#    Then Я вижу таблицу "websites" с веб-сайтами
#      | name                     |
#      | http://wwww.example2.com |
