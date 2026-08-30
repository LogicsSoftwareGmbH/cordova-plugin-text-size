# cordova-plugin-text-size

Cordova plugin: reports the system text size (Dynamic Type — *Settings › Display & Brightness › Text Size*) as a percentage of the default size, once and on every change. The app applies it to its WebView content itself.

## Why

`WKWebView` only applies Dynamic Type to text declared with `font: -apple-system-body` (and the other `-apple-system-*` styles). Any page that sets its own font family or `px` sizes ignores the slider completely. The Android WebView, by contrast, follows the system font size by default (`WebSettings.textZoom`). This plugin closes that gap: it tells the page the same factor the OS uses, and the page scales its text with `-webkit-text-size-adjust`, the very mechanism WebKit uses for Dynamic Type (text scales, boxes don't).

Nothing is stored — the OS setting is the single source of truth, exactly like on Android.

**iOS only for now.** The Android WebView already follows the system font size on its own (`WebSettings.textZoom` is initialised from the font scale); it just needs an app restart to pick up a change. An Android side that applies the new scale live (`onConfigurationChanged` → `setTextZoom`) is a possible future addition — the plugin id is platform-neutral for that reason.

## API

```js
// once
cordova.plugins.textSize.getTextZoom(function (pct) { ... });

// initial value + every change (delivered when the app returns to the foreground after a Settings change)
cordova.plugins.textSize.watch(function (pct) {
	document.documentElement.style.webkitTextSizeAdjust = pct === 100 ? "" : pct + "%";
});
```

`pct` is an integer: `UIFont.preferredFont(forTextStyle: .body).pointSize / 17 × 100`, i.e. 100 at the default setting ("Large"). Values by category: xS 82, S 88, M 94, **L 100**, xL 112, xxL 124, xxxL 135, accessibility AX1 165, AX2 194, AX3 235, AX4 276, AX5 312. The per-app text size (*Settings › Accessibility › Per-App Settings*) is honoured. Clamp on the JS side if your layout can't take the accessibility sizes.

Only one watcher per page; `watch` replaces an earlier watcher, and a page reload resets it (`onReset`), so call `watch` again after `deviceready` on every page load.

## Install

```
cordova plugin add cordova-plugin-text-size
```

or in `config.xml`:

```xml
<plugin name="cordova-plugin-text-size" spec="1.0.1" />
```

The plugin is also installable straight from GitHub (`cordova plugin add https://github.com/LogicsSoftwareGmbH/cordova-plugin-text-size.git#1.0.1`).

No permissions, no `Info.plist` entries, no window/scene access (safe with the UIScene lifecycle of cordova-ios 8).

## License

MIT — see [LICENSE](LICENSE). © 2026 Logics Software GmbH.
