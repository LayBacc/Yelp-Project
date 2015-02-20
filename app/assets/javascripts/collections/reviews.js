App.Collections.Reviews = Backbone.Collection.extend({
	initialize: function(models, options) {
		this.restaurant_id = models.restaurant_id;
		this.deferred = this.fetch();
	},

	url: function() {
		return '/api/v1/restaurants/' + this.restaurant_id.toString() + '/reviews';
	},

	parse: function(resp, xhr) {
		return resp.reviews;
	}
});