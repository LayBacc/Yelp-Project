App.Views.Feedback = Backbone.View.extend({
	initialize: function() {
		this.feedbackForm();
	},

	events: {
		'click #feedback_trigger': 'toggleBarStatus',
		'click #send_feedback': 'sendFeedback',
		'click #more_feedback': 'feedbackForm'
	},

	render: function() {
		this.$el.html(JST['feedback']());
		return this;
	},

	toggleBarStatus: function() {
		if ($('#feedback_box').hasClass('hidden')) {
			$('#feedback_box').fadeIn();
			$('#feedback_box').removeClass('hidden');
		}
		else {
			$('#feedback_box').addClass('hidden');
			$('#feedback_box').fadeOut();
		}
	},

	sendFeedback: function() {
		var _this = this;
		$.ajax({
			url: '/api/v1/feedbacks',
			type: 'post',
			data: { feedback: { body: $('#feedback_body').val() } },
			success: function(data) {
				_this.afterSend();
			}
		})
	},

	afterSend: function() {
		var header = '<p>' + I18n.feedback.thanks + '</p>';
		var button = '<button id="more_feedback" class="btn btn-primary">' + I18n.feedback.more + '</button>';
		$('#feedback_box').html(header + button);
	},

	feedbackForm: function() {
		var header = '<p>' + I18n.feedback.heading + '</p>';
		var form = '<textarea id="feedback_body" class="form-control" placeholder="e.g. the review system ist\'t intuitive, there aren\'t enough images etc."></textarea><br>';
		var submit = '<button id="send_feedback" class="btn btn-primary">Send</button>';
		$('#feedback_box').html(header + form + submit);
	}
});