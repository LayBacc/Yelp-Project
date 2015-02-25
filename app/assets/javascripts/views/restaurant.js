App.Views.Restaurant = Backbone.View.extend({
	initialize: function(params) {
		$(document).ready($.proxy(this.loadGMScripts, this));
		var matches = new App.Collections.Matches({ category_id: this.model.attributes.categories[0].id, 
			subarea: this.model.attributes.subarea 
		});
		this.match_view = new App.Views.Match({ collection: matches, model: this.model });
		this.reviews = params.reviews;
	},

	render: function() {
		console.log(this.model);
		this.$el.html(JST['restaurants/show']({ restaurant: this.model }));
		this.$('#match_form').html(this.match_view.render().el);

		var _this = this;
		this.reviews.deferred.done(function() {
			var reviews = _this.reviews.toJSON();
			_this.renderReviews(reviews);
		});

		return this;
	},

	initMap: function() {
		var mapOptions = {
			center: { 
				lat: this.model.attributes.latitude,
				lng: this.model.attributes.longitude
			},	
			disableDefaultUI: true,
			disableDoubleClickZoom: true,
			draggable: false,
			scrollwheel: false,
			zoom: 15
		};

		this.map = new google.maps.Map(document.getElementById('restaurant_map'), mapOptions);

		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(this.model.attributes.latitude, this.model.attributes.longitude),
			map: this.map
		});

	},

	loadGMScripts: function() {
		var _this = this;
		google.load('maps', '3', {
			callback: function() {
				_this.initMap();
			}
		});
	},

	renderReviews: function(reviews) {
		if (reviews.length == 0) { 
			var notice = '<p>There are no reviews for this restaurant.</p>';
			var review_path = '/restaurants/' + this.model.escape('id') + '/reviews/new';
			var button = '<a href="' + review_path + '" class="btn btn-primary">Write a Review</a>'
			this.$('#restaurant_reviews').html(notice + button);
			return;
		}
		
		for (var i = 0; i < reviews.length; ++i) {
			var review = reviews[i];
			
			// TODO - use jquery to write clear code
			var html = '<li><div class="review-profile-pic"><a href="/users/' + review.user_id + '"><img src="' + review.profile_image_url + '" /></a></div>';
			html += '<div class="review-first-name"><a href="/users/' + review.user_id + '">' + review.first_name + '</a></div>';
			html += '<div class="review-body">' + review.rating + '<br>' + review.body + '</div></li>';
			this.$('#restaurant_reviews').append(html);
		}
	}
});
