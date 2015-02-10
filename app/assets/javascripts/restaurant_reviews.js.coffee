window.RestaurantReviews =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: (data) ->
   	console.log('Backbone app starting')
   	new RestaurantReviews.Routers.App(data)
   	Backbone.history.start(pushState: true)

window.App = window.RestaurantReviews

$(document).ready ->
  RestaurantReviews.initialize()
