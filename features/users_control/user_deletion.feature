Feature: Удаление пользователей
  Я, как администратор,
  Когда нахожусь на странице управления пользователями
  Могу удалять их

  Background:
    Given Существуют следующие пользователи
      | username   | password | email               | roles    |
      | t_admin    | 1111     | t_admin@test.com    | admin    |
      | t_operator | 1111     | t_operator@test.com | operator |
      | t_agent    | 1111     | t_agent@test.com    | agent    |

  Scenario: Администратор может удалить пользователя
    Given Я - "администратор", авторизованный в системе
    When Я удаляю пользователя "t_operator"
    Then Я попадаю на страницу "Пользователи"
    And Я не вижу пользователя "t_operator"

  Scenario: Администратор не может удалить сам себя.
    Given Я - "администратор", авторизованный в системе
    When Я нахожусь на странице "Пользователи"
    Then Я не могу удалить самого себя

  @allow-recue
  Scenario: Администратор не может удалить пользователя, для которого существуют связанные с ним объекты.
    Given Я - "администратор", авторизованный в системе
    And Пользователь "t_operator" связан с существующей компанией
    When Я удаляю пользователя "t_operator"
    Then Я вижу сообщение, что нельзя удалить пользователя.