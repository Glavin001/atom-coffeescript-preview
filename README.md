# [CoffeeScript Preview for Atom](https://github.com/Glavin001/atom-coffeescript-preview)

---

### *DEPRECATED*: Use [`Preview` for Atom](https://github.com/Glavin001/atom-preview) which supports CoffeeScript and many, many more!
### *All future development will be on the `Preview` package.* Please report new issues [there](https://github.com/Glavin001/atom-preview/issues).

---

Atom Package: https://atom.io/packages/coffeescript-preview

```bash
apm install coffeescript-preview
```

Or Settings/Preferences ➔ Packages ➔ Search for `coffeescript-preview`

## Features

- [x] Preview CoffeeScript as JavaScript in tab
- [x] Live updating of preview
- [x] Shows loading and error messages
- [x] [Updates on Tab Change](https://github.com/Glavin001/atom-coffeescript-preview/issues/3)
- [x] [Highlights using active Atom theme](https://github.com/Glavin001/atom-coffeescript-preview/issues/5)

## Package Settings

- `Refresh Debounce Period` (milliseconds) -
Set the debounce rate for preview refreshing.
For instance, if you type or switch tabs,
how long of a pause before the preview refreshes.
- `Update On Tab Change` (boolean) -
Should the preview update to the currently active tab?

## Screenshots

### Preview CoffeeScript as JavaScript

![screenshot](https://raw.githubusercontent.com/Glavin001/atom-coffeescript-preview/master/screenshot.png)

### Syncing with Tab Changes

![screencapture](https://cloud.githubusercontent.com/assets/1885333/3576573/99212e10-0b93-11e4-8cd5-9da29e9230dd.gif)


[npm]: https://www.npmjs.org/package/generator-atom-package
[atom-doc]: https://atom.io/docs/latest/creating-a-package "Official documentation"
