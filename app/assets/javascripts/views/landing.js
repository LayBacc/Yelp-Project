App.Views.Landing = Backbone.View.extend({
	initialize: function() {
		this.curr_left;
		this.curr_right;
	},

	events: {
		'click .match-button': 'matchResult'
	},

	render: function() {
		var _this = this;
		this.collection.deferred.done(function() {
			var data = _this.collection.toJSON();
			_this.initializeContestants();
			console.log('Backbone view landing render()');
		});

		this.$el.html(JST['landing']({ matches: this.colleciton }));
		return this;
	},

	initializeContestants: function() {
		// Populate the first two contestants
		this.curr_left = this.collection.pop().attributes;
		this.curr_right = this.collection.pop().attributes;

		if (this.curr_left.front_image_url) {
			$('.left-image').html('<img src="' + this.curr_left.front_image_url + '" />');
		}
		else {
			$('.left-image').html('<img src="http://placehold.it/300x300" />');	
		}
		$('.left-description').html(this.curr_left.name);

		if (this.curr_right.front_image_url) {
			$('.right-image').html('<img src="' + this.curr_right.front_image_url + '" />');
		}
		else {
			$('.right-image').html('<img src="http://placehold.it/300x300" />');	
		}
		$('.right-description').html(this.curr_right.name);
	},

	matchResult: function(e) {
		if (e.target.id == 'draw') {
			this.matchDraw();
			return;
		}

		var restaurant = this.curr_left;
		if (e.target.id.split('_')[0] == 'right') {
			restaurant = this.curr_right;
		}

		var status = e.target.id.split('_')[1];
		if (status == 'win') {
			this.matchWinner(restaurant);
		}
		else {
			this.matchNeverBeen(restaurant);
		}
	},

	matchDraw: function() {
		console.log('match draw');
		$.ajax({
			url: 'api/v1/matches',
			type: 'post',
			data: { 
				first_id: this.curr_left.id,
				second_id: this.curr_right.id,
				
			}
		});
	},

	matchWinner: function(restaurant) {
		console.log('winner: ', restaurant.name);
	},

	matchNeverBeen: function(restaurant) {
		console.log('never been to ', restaurant.name);
	}
});