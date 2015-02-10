App.Views.Landing = Backbone.View.extend({
	render: function() {
		var _this = this;
		this.collection.deferred.done(function() {
			var data = _this.collection.toJSON();
			
			// Populate the first two contestants
			console.log(data);
		});

		this.$el.html(JST['landing']({ matches: this.colleciton }));
		return this;
	}
});