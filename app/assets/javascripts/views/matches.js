App.Views.Matches = Backbone.View.extend({
	initialize: function() {
		this.params = parse_url_params();
		this.matches = new App.Collections.Matches({ category: this.params.category, subarea: this.params.subarea, latitude: this.params.latitude, longitude: this.params.longitude });
		this.match_view = new App.Views.Match({ collection: this.matches, parent: this });
		this.on('matchesDone', this.matchesDone);
	},

	events: {

	},

	render: function() {
		this.$el.html(JST['matches']());
		this.$el.append(this.match_view.render().el);
		this.$('#subarea_autocomplete').val(this.matches.subarea);
		return this;
	},

	matchesDone: function() {
		window.location = '/restaurants' + params_string(this.params);
	}
});
