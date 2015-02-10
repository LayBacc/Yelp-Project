RestaurantReviews.Routers.App = Backbone.Router.extend({
	routes: {
		'': 'landing',
		'restaurants': 'restaurants'
	},

	initialize: function() {
		console.log('initialize router');
		// TODO - randomly get a category
	},

	landing: function() {
		console.log('TODO - fetch matches for landing page');
		// TODO - start with random category, in a central location, instead of hard-coding
		this.matches = new App.Collections.Matches({ category: '和食', latitude: 35.6895, longitude: 139.6917 });

		var view = new App.Views.Landing({ collection: this.matches });
		$('.match-container').html(view.render().$el);	// change to a container
	},

	restaurants: function() {
		console.log('TODO - fetch restaurants and matches for search results');
	}
});