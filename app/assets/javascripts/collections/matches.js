App.Collections.Matches = Backbone.Collection.extend({
	initialize: function(models, options) {
		this.category_id = models.category_id;
		this.deferred = this.fetch({
			data: {
				category_id: this.category_id,
				subarea: models.subarea
			}
		});
	},

	url: function() {
		return '/api/v1/matches';
	},

	parse: function(resp, xhr) {
		return resp.restaurants;
	}
});