App.Collections.Matches = Backbone.Collection.extend({
	initialize: function(models, options) {
		// https://quickleft.com/blog/leveraging-deferreds-in-backbonejs/
		this.deferred = this.fetch({
			data: {
				category: models.category,
				latitude: models.latitude,
				longitude: models.longitude
			}
		});
	},

	// TODO - support also location (subarea)
	url: function() {
		return '/api/v1/matches';
	},

	parse: function(resp, xhr) {
		return resp.restaurants;
	}
});