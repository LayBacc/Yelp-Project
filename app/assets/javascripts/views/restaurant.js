App.Views.Restaurant = Backbone.View.extend({
	initialize: function() {
		google.maps.event.addDomListener(window, 'load', this.initMap);
	},

	render: function() {
		this.$el.html(JST['restaurants/show']({ restaurant: this.model }));
		return this;
	},

	initMap: function() {
		console.log(this.restaurant);
		
		var mapOptions = {
			center: { lat: -34.397, lng: 150.644 },
			zoom: 8
		};

		this.map = new google.maps.Map(document.getElementById('restaurant_map'), mapOptions);
	}
});