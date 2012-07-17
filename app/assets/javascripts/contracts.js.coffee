# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
# Главный объект
#
@gts_contract =
  id: '-1'

##
#
# Обработчик выпадающего меню со списком продуктов
#
@onProdSelect = ->
  el =  $('#add_prod_link')

  # Прячем или показываем ссылку для добавления продукта
  if $('#select_product_id').val() != ''
    el.show()
    # меняем саму ссылку
    s = '/contracts/' + gts_contract.id + '/add_product/' + $('#select_product_id').val()
    el.attr('href', s)
  else
    el.hide()

# прячем ссылку для добавления продукта, т.к. по умолчанию нет выбранных объектов
$ ->
  $('#add_prod_link').hide()
