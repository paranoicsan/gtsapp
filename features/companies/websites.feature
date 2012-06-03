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
#
  @javascript
  Scenario: Один и тот же веб-сайт нельзя добавить в систему дважды
    Given Я - пользователь "t_admin" с паролем "1111"
    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    When Я ввожу "http://wwww.example.com" в поле "branch_website"
    And Я нажимаю на кнопку "branch_add_website"
    Then Я вижу сообщение "Такой веб-сайт уже существует!"

  @javascript
  Scenario: Администратор может удалить веб-сайт из филиала
    Given Я - пользователь "t_admin" с паролем "1111"
    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    When Я удаляю веб-сайт "http://wwww.example.com" из филиала "Филиал рогов"
    Then Я вижу таблицу "websites" с веб-сайтами
      | name                    |
      | http://wwww.example2.com |

  @javascript
  Scenario: Пользователь латиницей может ввести адрес только в формате "http://www.example.com"
    Given Я авторизован в системе
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    When Я ввожу "www.example.com" в поле "branch_website"
    And Я нажимаю на кнопку "branch_add_website"
    Then Я вижу сообщение "Неверный формат веб-сайта."
    And Я ввожу "http://example.m" в поле "branch_website"
    And Я нажимаю на кнопку "branch_add_website"
    And Я вижу сообщение "Неверный формат веб-сайта."
    And Я ввожу "example.com" в поле "branch_website"
    And Я нажимаю на кнопку "branch_add_website"
    And Я вижу сообщение "Неверный формат веб-сайта."

  Scenario: Пользователь не может удалить веб-сайт из филиала
    Given Я - пользователь "t_agent" с паролем "1111"
    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    Then Я не вижу ссылки "Удалить" в таблице "websites"

  @javascript
  Scenario: Оператор может удалить веб-сайт из филиала
    Given Я - пользователь "t_operator" с паролем "1111"
    And Существуют следующие веб-сайты дял филиала "Филиал рогов"
      | name                    |
      | http://wwww.example.com |
      | http://wwww.example2.com |
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    When Я удаляю веб-сайт "http://wwww.example.com" из филиала "Филиал рогов"
    Then Я вижу таблицу "websites" с веб-сайтами
      | name                     |
      | http://wwww.example2.com |
