App.Views.Restaurant = Backbone.View.extend({
	initialize: function() {
		$(document).ready($.proxy(this.loadGMScript, this));
	},

	render: function() {
		var _this = this;
		this.collection.deferred.done(function() {
			var data = _this.collection.toJSON();
			_this.initializeContestants();
		});

		this.$el.html(JST['restaurants/show']({ restaurant: this.model }));

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
