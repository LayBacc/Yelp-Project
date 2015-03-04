App.Views.Search = Backbone.View.extend({
	initialize: function() {
		var params = parse_url_params();
		this.matches = new App.Collections.Matches({ category: params.category, subarea: params.subarea, latitude: params.latitude, longitude: params.longitude });
		this.match_view = new App.Views.Match({ collection: this.matches, parent: this });
	},

	events: {

	},

	render: function() {
		this.$el.html(JST['search']());
		this.$el.append(this.match_view.render().el);
		this.$('#subarea_autocomplete').val(this.matches.subarea);
		return this;
	}
});