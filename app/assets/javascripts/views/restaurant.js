App.Views.Restaurant = Backbone.View.extend({
	initialize: function(params) {
		$(document).ready($.proxy(this.loadGMScript, this));
		var matches = new App.Collections.Matches({ category_id: this.model.attributes.categories[0].id, 
			subarea: this.model.attributes.subarea 
		});
		this.match_view = new App.Views.Match({ collection: matches, model: this.model });

		var _this = this;
		this.reviews = params.reviews;
		this.reviews.deferred.done(function() {
			var reviews = _this.reviews.toJSON();
			_this.renderReviews(reviews);
		});
	},

	render: function() {
		this.$el.html(JST['restaurants/show']({ restaurant: this.model }));
		this.$('#match_form').html(this.match_view.render().el);
		return this;
	},

	initMap: function() {
		var mapOptions = {
			center: { 
				lat: this.model.attributes.latitude,
				lng: this.model.attributes.longitude 
			},
			disableDefaultUI: true,
			draggable: false,
			zoom: 15
		};

		new google.maps.Map(document.getElementById('restaurant_map'), mapOptions);
	},

	loadGMScript: function() {
		var _this = this;
		google.load('maps', '3', {
			callback: function() {
				_this.initMap();
			}
		});
	},

	renderReviews: function(reviews) {
		for (var i = 0; i < reviews.length; ++i) {
			var review = reviews[i];
			console.log(review.body);
			$('#restaurant_reviews').append(review.body);
		}
	}
});
