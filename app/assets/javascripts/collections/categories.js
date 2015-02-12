App.Collections.Categories = Backbone.Collection.extend({
	initialize: function(models, options) {
		this.deferred = this.fetch();
	},

	url: function() {
		return '/api/v1/categories';
	},

	parse: function(resp, xhr) {
		return resp.categories;
	}
});