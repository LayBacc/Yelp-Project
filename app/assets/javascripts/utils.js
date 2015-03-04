function parse_url_params() {
	var params = {}
	location.search.substr(1).split("&").forEach(function(pair) {
		pair = pair.split('=');
		params[pair[0]] = pair[1];
	});
	return params;
}

function params_string(params) {
    var p_array = [] 
    for (var key in params) {
        p_array.push(key + '=' + params[key]);
    }

    return '?' + p_array.join('&');
}

function user_location() {
	if ((window.user_latitude && window.user_longitude) || window.location_not_supported) {
		return;
	}

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
        	window.user_latitude = position.coords.latitude;
        	window.user_longitude = position.coords.longitude;
        }, function(error) {
        	if (error.code == error.PERMISSINO_DENIED) {
        		window.location_declined = true;
        	}
        });
    } else {
        window.location_not_supported = true;
    }
}

function clean_attributes(obj) {
    for (var i in obj) {
        if (obj[i] === null || obj[i] === undefined) {
            delete obj[i];
        }
    }
    return obj;
}
