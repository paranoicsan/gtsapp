Feature: Большие списки компаний разбиваются на страницы.

  Background:
    Given Существуют 100 компаний с названиями на вариацию "Test Pagination" и параметрами
      | company_status |
      | Активна        |

  Scenario: Список компаний в разделе Компаний разбит на страницы с сохранением функционала.
    Given Я авторизован в системе
    When Я нахожусь на странице "Компании"
    Then Я вижу только 25 компаний в таблице "index"
    And Я вижу разбивку на страницы