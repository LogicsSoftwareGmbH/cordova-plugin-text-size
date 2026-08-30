var exec = require("cordova/exec");

/**
 * System text size (iOS Dynamic Type) as a percentage of the default size:
 * UIFont.preferredFont(forTextStyle: .body).pointSize / 17 * 100, i.e. 100 at the default
 * setting ("Large"), 82 at the smallest, 312 at the largest accessibility size.
 * iOS only - on Android the WebView already follows the system font size on its own.
 */
module.exports = {
	/**
	 * Reads the current percentage once.
	 * @param {function(number)} success	receives the percentage (integer)
	 * @param {function(string)} [error]
	 */
	getTextZoom: function (success, error) {
		exec(success, error, "TextSize", "getTextZoom", []);
	},

	/**
	 * Fires success immediately with the current percentage and again whenever the user changes the system
	 * text size (UIContentSizeCategoryDidChangeNotification, delivered when the app returns to the foreground).
	 * Only one watcher per page; a later call replaces the earlier one.
	 * @param {function(number)} success	receives the percentage (integer), repeatedly
	 * @param {function(string)} [error]
	 */
	watch: function (success, error) {
		exec(success, error, "TextSize", "watch", []);
	}
};
