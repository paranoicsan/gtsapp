Feature: Система просмотра договоров.
  Как пользователь, я хочу иметь возможность просматривать заключенные договора.

  Background:
    Given Существуют следующие компании
      | title         |
      | Рога и копыта |
    And Существуют следующие пользователи
      | username   | password | email               | roles    |
      | t_admin    | 1111     | t_admin@test.com    | admin    |
      | t_operator | 1111     | t_operator@test.com | operator |
      | t_agent    | 1111     | t_agent@test.com    | agent    |
    And Существуют следующие коды проекта
      | name  |
      | КОД-1 |
    And Существуют следующие договора
      | number | project_code_id | date_sign  | amount | contract_status_id | company_id |
      | ДОГ-01 | 1               | 23.08.2010 | 3450.8 | 1                  | 1          |
      | ДОГ-02 | 1               | 23.08.2010 | 3450.8 | 2                  | 1          |

  Scenario: Пользователь види заключенные договора на странице компании.
    Given Я - пользователь "t_agent" с паролем "1111"
    When Я нахожусь на странице компании "Рога и копыта"
    Then Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | активен         |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | не активен      |

  Scenario: Пользователь может перейти на страницу договора со списка договоров на странице компании.
    Given Я - пользователь "t_agent" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    And Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | активен         |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | не активен      |
    When Я нажимаю на ссылку "ДОГ-02"
    Then Я нахожусь на странице договора с номером "ДОГ-02"

  Scenario: Пользователь видит дату занесения договора в СУБД.
    Given Я - пользователь "t_admin" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    And Я нажимаю на ссылку "Создать договор"
    When Я создаю договор через веб-интерфейс с параметрами
      | number |
      | ДОГ-03 |
    Then Я вижу текущую дату для поля "Добавлен в систему:"
