App.Views.Match = Backbone.View.extend({
	initialize: function(options) {
		this.parent = options.parent;
		
		var _this = this;
		this.collection.deferred.done(function() {
			var data = _this.collection.toJSON();
			_this.initializeContestants();
		});
	},

	events: {
		'click .match-button': 'matchResult',
		'click .match-image': 'matchResult'
	},

	render: function() {
		this.$el.html(JST['match']({ matches: this.colleciton }));		
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
				category_id: this.collection.category_id,
				winner: winner
			}
		};
	},

	matchDraw: function() {
		var _this = this;

		$.ajax({
			url: '/api/v1/matches',
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
		var winner, other_side;
		if (side == 'left') {
			winner = 1;
			other_side = 'right';
		}
		else {
			winner = 2;
			other_side = 'left';
		}

		$.ajax({
			url: '/api/v1/matches',
			type: 'post',
			data: _this.matchData(winner),
			success: function(data) {
				_this.updateContestant(other_side);
			}
		});
	},

	matchNeverBeen: function(side) {
		var _this = this;
		var restaurant = side == 'left' ? this.curr_left : this.curr_right;

		$.ajax({
			url: '/api/v1/visits',
			type: 'post',
			data: { 
				visit: { 
					restaurant_id: restaurant.id,
					visited: false
				} 
			},
			success: function() {
				_this.updateContestant(side);
			}
		});
	},

	nextRestaurant: function(curr) {
		if (this.collection.length == 0) {
			this.parent.trigger('matchesDone');
			return undefined;
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

		if (!restaurant) {
			name = I18n.no_more_restaurants;
			front_image_url = 'http://placehold.it/200x200"';
		}
		else if (restaurant.front_image_url == undefined) {
			name = restaurant.name;
			front_image_url = 'http://placehold.it/200x200"';
		}
		else {
			name = restaurant.name;
			front_image_url = restaurant.front_image_url;
		}

		if (front_image_url) {
			$('.' + side + '-image').html('<img src="' + front_image_url + '" id="' + side + '_win" class="center-cropped" />');
		}

		$('.' + side + '-description').html(name);
	},

	fetchMatches: function() {
		var subarea;
		var category_id;
		
		if (this.model) {
			subarea = this.model.attributes.subarea;
			category_id = this.model.attributes.categories[0].id;
		}
		else {
			subarea = $('#subarea_autocomplete').val();
			category_id = $('#categories_select').val();
		}

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
				$('#match_message').html(I18n.no_more_restaurants);
			}
		});
	}
});