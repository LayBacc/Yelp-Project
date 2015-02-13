App.Views.Landing = Backbone.View.extend({
	initialize: function(params) {
		this.categories = params.categories;
	},

	events: {
		'click .match-button': 'matchResult',
		'change #subarea_autocomplete': 'fetchMatches',
		'change #categories_select': 'fetchMatches'
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

	nextRestaurant: function(curr) {
		if (this.collection.length == 0) {
			this.fetchMatches();
			return curr;
		}
		return this.collection.pop().attributes;
	},

	updateContestant: function(side) {
		var name, front_image_url;
		if (side == 'left') {
			this.curr_left = this.nextRestaurant(this.curr_left);
			restaurant = this.curr_left;
		}
		else {
			this.curr_right = this.nextRestaurant(this.curr_right);
			restaurant = this.curr_right;
		}

		if (restaurant == undefined) {
			name = 'There are no more restaurants';
			front_image_url = 'http://placehold.it/300x300"';
		}
		else if (restaurant.front_image_url == undefined) {
			name = restaurant.name;
			front_image_url = 'http://placehold.it/300x300"';
		}
		else {
			name = restaurant.name;
			front_image_url = restaurant.front_image_url;
		}

		if (front_image_url) {
			$('.' + side + '-image').html('<img src="' + front_image_url + '" />');
		}

		$('.' + side + '-description').html(name);
	},

	fetchMatches: function() {
		var subarea = $('#subarea_autocomplete').val();
		var category_id = $('#categories_select').val();

		if (subarea == undefined || subarea == '') {
			return;
		}

		this.collection.deferred = this.collection.fetch({
			data: {
				category_id: category_id,
				subarea: subarea
			}
		});

		var _this = this;
		this.collection.deferred.done(function() {
			if (_this.collection.length > 1) {
				_this.initializeContestants();
			}
			else {
				console.log('no more restaurants, please change parameters');
			}
		});
	}
});