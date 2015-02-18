App.Views.Restaurant = Backbone.View.extend({
	initialize: function() {
		$(document).ready($.proxy(this.loadGMScript, this));
		var matches = new App.Collections.Matches({ category_id: this.model.attributes.categories[0].id, 
			subarea: this.model.attributes.subarea 
		});
		this.match_view = new App.Views.Match({ collection: matches });
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
	}
});
