App.Collections.Categories = Backbone.Collection.extend({
	initialize: function(models, options) {
		this.deferred = this.fetch();
	},

	url: function() {
		return '/api/v1/categories';
	}
});