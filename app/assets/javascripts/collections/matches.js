App.Collections.Matches = Backbone.Collection.extend({
	initialize: function(models, options) {
		this.category_id = models.category_id;
		this.category = models.category;
		this.subarea = models.subarea;
		this.latitude = models.latitude;
		this.longitude = models.longitude;

		this.deferred = this.fetch({
			data: clean_attributes({
				category: this.category,
				category_id: this.category_id,
				subarea: this.subarea,
				latitude: this.latitude,
				longitude: this.longitude
			})
		});
	},

	url: function() {
		return '/api/v1/matches';
	},

	parse: function(resp, xhr) {
		return resp.restaurants;
	}
});