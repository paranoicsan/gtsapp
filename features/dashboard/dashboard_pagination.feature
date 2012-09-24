Feature: Большие списки должны разбиваться на страницы.
  Как пользователь, я хочу видеть в сводке разбитые на страницы большие списки

  Background:
    Given Существуют следующие пользователи
      | username   | password | email               | roles    |
      | t_admin    | 1111     | t_admin@test.com    | admin    |
      | t_operator | 1111     | t_operator@test.com | operator |
      | t_agent    | 1111     | t_agent@test.com    | agent    |
    And Существуют 100 компаний с названиями на вариацию "Test Pagination" и параметрами
      | company_status  | author_user |
      | На рассмотрении | t_agent     |

  Scenario Outline: Список неактивированных компаний в разеделе "Сводка" разбит на страницы.
    Given Я - пользователь "<user>" с паролем "1111"
    When Я нахожусь на странице "Сводка"
    Then Я вижу только 10 рядов в таблице "suspended_companies_list"
    And Я вижу разбивку на страницы
  Examples:
    | user |
    | t_admin |
    | t_operator |
    | t_agent |
