App.Views.Landing = Backbone.View.extend({
	initialize: function(params) {
		this.categories = params.categories;
		var matches = new App.Collections.Matches({ category_id: 1, subarea: '新宿' });
		this.match_view = new App.Views.Match({ collection: matches });
	},

	events: {
		'blur #subarea_autocomplete': 'fetchMatches',
		'change #categories_select': 'fetchMatches'
	},

	render: function() {
		var _this = this;
		
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

		this.$el.html(JST['landing']());
		this.$el.append(this.match_view.render().el);
		return this;
	},

	fetchMatches: function() {
		this.match_view.fetchMatches();
	}
});
