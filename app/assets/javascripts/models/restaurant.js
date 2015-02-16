App.Models.Restaurant = Backbone.Model.extend({
	urlRoot: '/api/v1/restaurants',
	parse: function(data) {
		return data.restaurant;
	}
});