App.Views.Landing = Backbone.View.extend({
	initialize: function(params) {
		this.categories = params.categories;
	},

	events: {
		'click .match-button': 'matchResult'
	},

	render: function() {
		var _this = this;
		this.collection.deferred.done(function() {
			var data = _this.collection.toJSON();
			_this.initializeContestants();
		});

		this.categories.deferred.done(function() {
			var categories = _this.categories.toJSON();
			for (var i = 0; i < categories.length; ++i) {
				var option = categories[i];
				$('#categories_select').append('<option value="' + option[0] + '">' + option[1] + '</option>');
			}

			$('#subarea_autocomplete').autocomplete({
				source: 'api/v1/locations/subareas'
			});
		});

		this.$el.html(JST['landing']({ matches: this.colleciton }));
		return this;
	},

	initializeContestants: function() {
		this.updateContestant('left');
		this.updateContestant('right');
	},

	matchResult: function(e) {
		if (e.target.id == 'draw') {
			this.matchDraw();
			return;
		}

		var side = e.target.id.split('_')[0];
		var restaurant = this.curr_left;
		if (side == 'right') {
			restaurant = this.curr_right;
		}

		var status = e.target.id.split('_')[1];
		if (status == 'win') {
			this.matchWinner(side);
		}
		else {
			this.matchNeverBeen(side);
		}
	},

	matchData: function(winner) {
		return {
			match: {
				first_id: this.curr_left.id,
				second_id: this.curr_right.id,
				winner: winner
			}
		};
	},

	matchDraw: function() {
		var _this = this;

		$.ajax({
			url: 'api/v1/matches',
			type: 'post',
			data: _this.matchData(0),
			success: function(data) {
				_this.updateContestant('left');
				_this.updateContestant('right');
			}
		});
	},

	matchWinner: function(side) {
		var _this = this;
		var winner = side == 'left' ? 1 : 2;
		
		$.ajax({
			url: 'api/v1/matches',
			type: 'post',
			data: _this.matchData(winner),
			success: function(data) {
				_this.updateContestant(side);
			}
		});
	},


	matchNeverBeen: function(side) {
		this.updateContestant(side);
		// TODO - save never_been in server
	},

	nextRestaurant: function() {
		var restaurant = this.collection.pop().attributes;
		if (restaurant == undefined) {
			// fetch()  but we need to know current category and location!
		}
		// TODO - check if there are no more restaurants from the server
		return restaurant;
	},

	updateContestant: function(side) {
		var front_image_url;
		if (side == 'left') {
			this.curr_left = this.nextRestaurant();
			front_image_url = this.curr_left.front_image_url;
			name = this.curr_left.name;
		}
		else {
			this.curr_right = this.nextRestaurant();
			front_image_url = this.curr_right.front_image_url;
			name = this.curr_right.name;
		}

		if (front_image_url) {
			$('.' + side + '-image').html('<img src="' + front_image_url + '" />');
		}
		else {
			$('.' + side + '-image').html('<img src="http://placehold.it/300x300" />');	
		}
		$('.' + side + '-description').html(name);
	}
});