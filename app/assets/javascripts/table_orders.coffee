# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'ready turbolinks:load', ->

    $('#callModal').click ->
      $('#exfood').hide()
      $('#food').show()
      $('#foodModal').modal 'show'

    $('#drinkModal').click ->
      $('#exdrink').hide()
      $('#drink').show()
      $('#drinksModal').modal 'show'

    $('#food').unbind("click").click (e) ->
      food = document.getElementById('foodSelect')
      food_id = food.options[food.selectedIndex].value
      food_name = food.options[food.selectedIndex].text
      customer_order = $('#orderFood').val()
      if(food_id == '')
        return

      $.ajax
        url: '/table_orders/foods.html'
        type: 'PUT'
        data: id: { food_id, customer_order }
        complete: (data) ->
          $('#foodModal').modal 'hide'


    $('#drink').unbind('click').click (e) ->
      drink = document.getElementById('drinkSelect')
      drink_id = drink.options[drink.selectedIndex].value
      customer_order = $('#orderDrink').val()
      if(drink_id == '')
        return

      $.ajax
        url: '/table_orders/drinks.html'
        type: 'PUT'
        data: id: {drink_id, customer_order}
        complete: (data) ->
          $('#drinkModal').modal 'hide'


    $('#foodDiv').unbind('click').on 'click', '#deleteFood', ->
      food_id = $(this).prev().val()
      customer_id = $('#orderFood').val()
      $.ajax
        url: '/table_orders.html'
        type: 'DELETE'
        data: id: {food_id, customer_id}


    $('#drinkList').unbind('click').on 'click','#deleteDrink', ->
      drink_id = $(this).prev().val()
      customer_id = $('#orderFood').val()
      $.ajax
        url: '/table_orders/remove_drinks.html'
        type: 'DELETE'
        data: id: {drink_id, customer_id}

    $('#foodDiv').unbind('click').on 'click','#exchangeFood', ->
      $('#food').hide()
      $('#exfood').show()
      food_id = $(this).prev().prev().val()
      $('#foodModal').modal 'show'
      exchangeFood(food_id)

    $('#drinkDiv').unbind('click').on 'click', '#exchangeDrink', ->
      $('#drink').hide()
      $('#exdrink').show()
      drink_id = $(this).prev().prev().val()
      $('#drinksModal').modal 'show'
      exchangeDrink(drink_id)

  exchangeFood = (food_id) ->
    $('#exfood').unbind("click").click (e) ->
        food = document.getElementById('foodSelect')
        food_id_to_exchange = food.options[food.selectedIndex].value
        customer_order = $('#orderFood').val()
        if(food_id_to_exchange == '')
          return

        $.ajax
          url: '/table_orders/exchange.html'
          type: 'PUT'
          data: id: { food_id, customer_order, food_id_to_exchange }
          complete: (data) ->
            $('#foodModal').modal 'hide'

  exchangeDrink = (drink_id) ->
    $('#exdrink').unbind("click").click (e) ->
        drink = document.getElementById('drinkSelect')
        drink_id_to_exchange = drink.options[drink.selectedIndex].value
        customer_order = $('#orderFood').val()
        if(drink_id_to_exchange == '')
          return

        $.ajax
          url: '/table_orders/exchange_drink.html'
          type: 'PUT'
          data: id: { drink_id, customer_order, drink_id_to_exchange }
          complete: (data) ->
            $('#foodModal').modal 'hide'

