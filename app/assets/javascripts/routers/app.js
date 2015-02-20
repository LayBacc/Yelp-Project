RestaurantReviews.Routers.App = Backbone.Router.extend({
	routes: {
		'': 'landing',
		'restaurants/:id': 'showRestaurant'
	},

	initialize: function() {
		console.log('initialize router');
		// TODO - randomly get a category the first time
	},

	landing: function() {
		// TODO - start with random category, in a central location, instead of hard-coding
		// select an index from 1 to 42

		this.categories = new App.Collections.Categories();
		var view = new App.Views.Landing({ categories: this.categories });

		$('.match-container').html(view.render().$el);
	},

	showRestaurant: function(id) {
		var restaurant = new App.Models.Restaurant({ id: id });
		var reviews = new App.Collections.Reviews({ restaurant_id: id });
		restaurant.fetch({
			success: function(r) {
				var matches = new App.Collections.Matches({ category_id: r.attributes.categories[0].id, subarea: r.attributes.subarea });
				var view = new App.Views.Restaurant({ model: r, collection: matches, reviews: reviews });
				$('#restaurant_container').html(view.render().$el);
			} 
		});
		
	}
});