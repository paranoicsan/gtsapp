Feature: У филиалов может быть несколько телефонов
  Как пользователь, я хочу добавлять к филиалам неограниченное количество
  телефонных номеров.

  Background:
    Given Существуют следующие компании
      | title         |
      | Рога и копыта |
      | Рюмочная      |
      | Пельменная    |
    And Существуют следующие формы собственности
      | name |
      | ООО  |
      | МУП  |
    And Существуют следующие филиалы для компании "Рога и копыта"
      | form_type | fact_name      | legel_name              |
      | ООО       | Филиал рогов   | Юр. имя филиала рогов   |
      | МУП       | Филиал рогов 2 | Юр. имя филиала рогов 2 |


  Scenario: Пользователь может добавить телефон к филиалу со страницы филиала
    Given Я авторизован в системе
    And Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    When Я создаю телефон с информацией
#      |contact|director|fax|mobile|mobile_refix|name|order_num|publishable|
#      |true   |true    |true|false|             |521627|1      |true      |
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|false|             |521627|1      |true      |приёмная   |
    Then Я попадаю на страницу филиала "Филиал рогов" компании "Рога и копыта"
    And Я вижу сообщение "Телефон создан. "

  Scenario: Пользователь может удалить телефон со страницы филиала
    Given Я авторизован в системе
    And Для филиала "Филиал рогов" компании "Рога и копыта" существует телефон
#      |contact|director|fax|mobile|mobile_refix|name|order_num|publishable|
#      |true   |true    |true|false|             |521627|1      |true      |
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|false|             |521627|1      |true      |приёмная   |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    And Я удаляю телефон
    Then Я не вижу таблицу "phones"

  Scenario: Пользователь может изменить информацию о телефоне со страницы филиала
    Given Я авторизован в системе
    And Для филиала "Филиал рогов" компании "Рога и копыта" существует телефон
#      |contact|director|fax|mobile|mobile_refix|name|order_num|publishable|
#      |true   |true    |true|false|             |521627|1      |true      |
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|false|             |521627|1      |true      |приёмная   |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    And Изменяю телефон новой информацией
#      |contact|director|fax|mobile|mobile_refix|name|order_num|publishable|
#      |true   |true    |true|true|921           ||2      |false     |
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|true|921           ||2      |false     |приёмная   |
    And Я попадаю на страницу филиала "Филиал рогов" компании "Рога и копыта"
    And Я вижу сообщение "Телефон изменён."

  Scenario: Пользователь видит список телефонов на странице филиала
    Given Я авторизован в системе
    And Для филиала "Филиал рогов" компании "Рога и копыта" существует телефон
#      |contact|director|fax|mobile|mobile_refix|name|order_num|publishable|
#      |true   |true    |true|false|             |521627|1      |true       |
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|false|             |521627|1      |true       |приёмная   |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    Then Я вижу таблицу "phones" с телефонами
      | order_num | cb_publishable |description| name   |
      | 1         | true           |приёмная| 521627 |

  @javascript
  Scenario: Пользователь не видит поле для ввода префикса мобильного оператора, если выключен
    checkbox "Мобильный" и наоборот
    Given Я авторизован в системе
    And Для филиала "Филиал рогов" компании "Рога и копыта" существует телефон
      |fax|mobile|mobile_refix|name|order_num|publishable|description|
      |true|false|             |521627|1      |true       |приёмная   |
    When Я нахожусь на странице филиала "Филиал рогов" компании "Рога и копыта"
    And Я нажимаю на ссылку "Изменить" с ключом "phone_edit"
    Then Я не вижу элемент "phone_mobile_refix_group"
    When Я помечаю checkbox c ключом "phone_mobile"
    Then Я  вижу элемент "phone_mobile_refix_group"

