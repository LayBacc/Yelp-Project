RestaurantReviews.Routers.App = Backbone.Router.extend({
	routes: {
		'': 'landing'
	},

	initialize: function() {
		console.log('initialize router');
		// TODO - randomly get a category the first time
	},

	landing: function() {
		// TODO - start with random category, in a central location, instead of hard-coding
		// select an index from 1 to 42

		this.matches = new App.Collections.Matches({ category_id: 1, subarea: '新宿' });
		this.categories = new App.Collections.Categories();
		var view = new App.Views.Landing({ collection: this.matches, categories: this.categories });

		$('.match-container').html(view.render().$el);
	}
});