## 6.1.0.1
* Return old Rails integration to fix strange issues.

## 6.1 “Bil-shaʿb wa lil-shaʿb”
* Change `transition` support to output more robust CSS.
* Add `:read-only` support.
* Add support for `appearance` with any values.
* Add loud `/*! autoprefixer: off */` control comments support.
* Convert `rotateZ` to `rotate` for `-ms-transform`.
* Use `postcss-value-parser` to carefully work with gradients.
* Remove `-ms-transform-style` and `-o-transform-style` that never existed.

## 6.0.3
* Fix old gradient direction warning.

## 6.0.2
* Remove unnecessary `-khtml-` prefix too.

## 6.0.1
* Fix `cross-fade()` support (by 一丝).

## 6.0 “Eureka”
* Remove Ruby on Rails 3 support.
* Remove Ruby 1.9 support.
* Remove `safe` option.
* Remove Opera 12.1 from default query.
* Add `image-set` support (by 一丝).
* Add `mask-border` support (by 一丝).
* Add `filter()` function support (by Vincent De Oliveira).
* Add `backdrop-filter` support (by Vincent De Oliveira).
* Add `element()` support (by Vincent De Oliveira).
* Add CSS Regions support.
* Add Scroll Snap Points support.
* Add `writing-mode` support.
* Add `::backdrop` support.
* Add `cross-fade()` support.
* Add other `break-` properties support.
* Add Microsoft Edge support (by Andrey Polischuk).
* Add `not` keyword and exclude browsers by query.
* Add version ranges `IE 6-9` (by Ben Briggs).
* Fix `filter` in `transition` support on Safari.
* Fix `url()` parsing.
* Fix `pixelated` cleaning.
* Always show old gradient direction warning.

## 5.2.1.3
* Update Can I Use database.
* Update internal libraries.

## 5.2.1.2
* Update Can I Use database.
* Update internal libraries.

## 5.2.1.1
* Update Can I Use database.
* Update internal libraries.

## 5.2.1
* Fix parent-less node issue on some cases (by Josh Gillies)

## 5.2.0.1
* Update Can I Use database.

## 5.2 “Dont tread on me”
* Add `appearance` support.
* Warn users on old gradient direction or flexbox syntax.
* Add `add: false` option to disable new prefixes adding.
* Make Autoprefixer 30% faster.
* Add prefixes for `pixelated` instead of `crisp-edges` in `image-rendering`.
* Do not add `::placeholder` prefixes for `:placeholder-shown`.
* Fix `text-decoration` prefixes.

## 5.1.11
* Update num2fraction to fix resolution media quuery (by 一丝).

## 5.1.10
* Do not generate `-webkit-image-rendering`.

## 5.1.9
* Fix DynJS compatibility (by Nick Howes).

## 5.1.8.1
* Update Can I Use database.

## 5.1.8
* Fix gradients in `mask` and `mask-image` properties.
* Fix old webkit prefix on some unsupported gradients.

## 5.1.7.1
* Update Can I Use database and JS libraries.
* Better support with Alaska runtime (by Jon Bardin).

## 5.1.7
* Fix placeholder selector (by Vincent De Oliveira).

# 5.1.6
* Use official `::placeholder-shown` selector (by Vincent De Oliveira).
* Fix problem with rails-html-sanitizer (by Alexey Vasiliev).

# 5.1.5
* Add transition support for CSS Masks properties.

# 5.1.4
* Use `-webkit-` prefix for Opera Mobile 24.

# 5.1.3.1
* Fix Rails 5 support (by Joshua Peek).

# 5.1.3
* Add IE support for `image-rendering: crisp-edges`.

# 5.1.2
* Add never existed `@-ms-keyframes` to common mistake.

## 5.1.1
* Safer value split in `flex` hack.

## 5.1 “Jianyuan”
* Add support for resolution media query (by 一丝).
* Higher accuracy while removing prefixes in values.
* Add support for logical properties (by 一丝).
* Add `@viewport` support.
* Add `text-overflow` support (by 一丝).
* Add `text-emphasis` support (by 一丝).
* Add `image-rendering: crisp-edges` support.
* Add `text-align-last` support.
* Return `autoprefixer.defaults` as alias to current `browserslist.defaults`.
* Save code style while adding prefixes to `@keyframes` and `@viewport`.
* Do not remove `-webkit-background-clip` with non-spec `text` value.
* Fix `-webkit-filter` in `transition`.
* Better support for browser versions joined on Can I Use
  like `ios_saf 7.0-7.1` (by Vincent De Oliveira).
* Fix compatibility with `postcss-import` (by Jason Kuhrt).
* Fix Flexbox prefixes for BlackBerry and UC Browser.
* Fix gradient prefixes for old Chrome.

## 5.0.0.3
* Fix error on `nil` in processor params.

## 5.0.0.2
* Fix for non-Rails environments.
* Add notice about unsupported ExecJS runtimes.
* Update Can I Use data.

## 5.0.0.1
* Fix issue on node.js runtime.

## 5.0 “Pravda vítězí”
* Use PostCSS 4.0.
* Use Browserslist to parse browsers queries.
* Use global `browserslist` config.
  Key `browsers` in `config/autoprefixer.yml` is now deprecated.
* Add `> 5% in US` query to select browsers by usage in some country.
* Add `object-fit` and `object-position` properties support.
* Add CSS Shape properties support.
* Fix UC Browser name in debug info.

## 4.0.2.2
* Update Can I Use data.
* Update some npm dependencies.

## 4.0.2.1
* Fix IE filter parsing with multiple commands.
* Update Can I Use dump.

## 4.0.2
* Remove `o-border-radius`, which is common mistake in legacy CSS.

## 4.0.1.1
* Use PostCSS 3.0.5 to parse complicated cases of CSS syntax.
* Update Can I Use dump.

## 4.0.1
* Fix `@supports` support with brackets in values (by Vincent De Oliveira).
* Fix Windows support (by Kamen Hursev).

## 4.0.0.1
* Update PostCSS to fix issue with empty comment.

## 4.0 “Indivisibiliter ac Inseparabiliter”
* Become 2.5 times fatser by new PostCSS 3.0 parser.
* Do not remove outdated prefixes by `remove: false` option.
* `map.inline` and `map.sourcesContent` options are now `true` by default.
* Add `box-decoration-break` support.
* Do not add old `-webkit-` prefix for gradients with `px` units.
* Use previous source map to show origin source of CSS syntax error.
* Use `from` option from previous source map `file` field.
* Set `to` value to `from` if `to` option is missing.
* Trim Unicode BOM on source maps parsing.
* Parse at-rules without spaces like `@import"file"`.
* Better previous `sourceMappingURL` annotation comment cleaning.
* Do not remove previous `sourceMappingURL` comment on `map.annotation: false`.

## 3.1.2
* Update Firefox ESR version from 24 to 31.

## 3.1.1
* Use Flexbox 2009 spec for Android stock browser < 4.4.

## 3.1 “Satyameva Jayate”
* Do not remove comments from prefixed values (by Eitan Rousso).
* Allow Safari 6.1 to use final Flexbox spec (by John Kreitlow).
* Fix `filter` value in `transition` in Webkits.
* Show greetings in Rake task if your browsers don’t require any prefixes.
* Add `<=` and `<` browsers requirement (by Andreas Lind).

## 3.0.1
* Update Can I Use data.

## 3.0 “Liberté, Égalité, Fraternité”
* All methods now receive browsers as options key, not separated argument.
* GNU format for syntax error messages from PostCSS 2.2.

## 2.2.20140804
* Fix UTF-8 support in inline source maps.
* Allow to miss `from` and `to` options in inline source maps.
* Update Can I Use data.

## 2.2 “Mobilis in mobili”
* Allow to disable Autoprefixer for some rule by control comment.
* Use PostCSS 2.1 with Safe Mode option and broken source line
  in CSS syntax error messages.

## 2.1.1
* Fix `-webkit-background-size` hack for `contain` and `cover` values.
* Don’t add `-webkit-` prefix to `filter` with SVG (by Vincent De Oliveira).

## 2.1 “Eleftheria i thanatos”
* Add support for `clip-path` and `mask` properties.
* Return `-webkit-` prefix to `filter` with SVG URI.

## 2.0.2
* Add readable names for new browsers from 2.0 release.
* Don’t add `-webkit-` prefix to `filter` with SVG URI.
* Don’t add `-o-` prefix 3D transforms.

## 2.0.1
* Save declaration style, when clone declaration to prefix.

## 2.0 “Hongik Ingan”
* Based on PostCSS 1.0.
  See [options changes](https://github.com/postcss/postcss/releases/tag/1.0.0).
* Restore visual cascade after declaration removing.
* Prefix declareation in `@supports` at-rule conditions.
* Add all browsers from Can I Use: `ie_mob`, `and_chr`, `and_ff`,
  `op_mob` and `op_mini`.

## 1.3.1
* Fix gradient hack, when `background` property contains color.

## 1.3 “Tenka Fubu”
* Add `text-size-adjust` support.
* Add `background-size` to support Android 2.
* Update Can I Use data.

## 1.2 “Meiji”
* Use Can I Use data from official `caniuse-db` npm package.
* Change versions to `x.x.x.y`, where `x.x.x` is Autoprefixer npm version
  and `y` is a `caniuse-db` date.

## 1.1 “Nutrisco et extingo”
* Add source map annotation comment support.
* Add inline source map support.
* Autodetect previous inline source map.
* Fix source maps support on Windows.
* Fix source maps support in subdirectory.
* Prefix selector even if it is already prefixed by developer.
* Change CSS indentation to create nice visual cascade of prefixes.
* Fix flexbox support for IE 10 (by Roland Warmerdam).
* Better `break-inside` support.
* Fix prefixing, when two same properties are near.

### 20140222:
* Add `touch-action` support.

### 20140226:
* Chrome 33 is moved to released versions.
* Add Chrome 36 data.

### 20140302:
* Add `text-decoration-*` properties support.
* Update browsers usage statistics.
* Fix `cascade` options without `browsers` option (by Dominik Porada).
* Use new PostCSS version.

### 20140319:
* Check already prefixed properties after current declaration.
* Normalize spaces before already prefixed check.
* Firefox 28 is moved to released versions.
* Add Firefox 31 data.
* Add some Blackberry data.

## 20140327:
* Don’t use `-ms-transform` in `@keyframes`, because IE 9 doesn’t support
  animations.
* Update BlackBerry 10 data.

## 20140403:
* Update browsers usage statistics.
* Opera 20 is moved to released versions.
* Add Opera 22 data.

## 20140410:
* Chrome 34 is moved to released versions.
* Add Chrome 37 data.
* Fix Chrome 36 data.

## 20140429:
* Fix `display: inline-flex` support by 2009 spec.
* Fix old WebKit gradient converter (by Sergey Belov).

## 20140430:
* Separate 2D and 3D transform prefixes to clean unnecessary `-ms-` prefixes.
* Firefox 29 is moved to released versions.
* Add Firefox 32 data.

### 20140510
* Do not add `-ms-` prefix for `transform` with 3D functions.
* Update browsers global usage statistics.

### 20140512
* Remove unnecessary `-moz-` prefix for `wavy` in `text-decoration`.
* Update Safari data for font properties.

### 20140521
* Chrome 36 is moved to released versions.
* Add Chrome 38 data.

### 20140523
* Opera 21 is moved to released versions.
* Add Opera 23 data.

### 20140605
* Allow to parse gradients without space between color and position.
* Add iOS 8, Safari 8 and Android 4.4.3 data.
* Update browsers usage statistics.

## 1.0 “Plus ultra”
* Source map support.
* Save origin indents and code formatting.
* Change CSS parser to PostCSS.
* Keep vendor hacks, which does right after unprefixed property.
* Show syntax errors if fixed sass-rails version if used.
* Rename compile() to process() and return result object, instead of CSS string.
* Rename inspect() to info().
* Allow to select last versions for specified browser.
* Add full browser names aliases: `firefox`, `explorer` and `blackberry`.
* Ignore case in browser names.
* Change license to MIT.
* Add prefixes inside custom at-rules.
* Add only necessary prefixes to selector inside prefixed at-rule.
* Safer backgrounds list parser in gradient hack.
* Prefix @keyframes inside @media.
* Don’t prefix values for CSS3 PIE properties.
* Use browserify to build standalone version.

### 20131225:
* Add ::placeholder support for Firefix >= 18.
* Fix vendor prefixes order.

### 20140103:
* Add webkit prefix for sticky position.
* Update browsers popularity statistics.

### 20140109:
* Add selectors and at-rules sections to debug info.
* Fix outdated prefixes cleaning.

### 20140110:
* Add `Firefox ESR` browser requirement.
* Opera 18 is moved to released versions.
* Add Opera 20 data.

### 20140117:
* Chrome 32 is moved to released versions.
* Add Opera 34 data.

### 20140130:
* Fix flexbox properties names in transitions.
* Add Chrome 35 and Firefox 29 data.

### 20140203:
* Android 4.4 stock browser and Opera 19 are moved to released versions.
* Add Opera 21 data.
* Update browsers usage statistics.

### 20140213:
* Add case insensitive to IE’s filter hack (by Dominik Schilling).
* Improve selector prefixing in some rare cases (by Simon Lydell).
* Firefox 27 is moved to released versions.
* Add Firefox 30 data.

## 0.8 “Unbowed, Unbent, Unbroken”
* Add more browsers to defaults ("> 1%, last 2 versions, ff 17, opera 12.1"
  instead of just "last 2 browsers").
* Keep vendor prefixes without unprefixed version (like vendor-specific hacks).
* Convert gradients to old WebKit syntax (actual for Android 2.3).
* Better support for several syntaxes with one prefix (like Flexbox and
  gradients in WebKit).
* Add intrinsic and extrinsic sizing values support.
* Remove never existed prefixes from common mistakes (like -ms-transition).
* Add Opera 17 data.
* Fix selector prefixes order.
* Fix browser versions order in inspect.

### 20130903:
* Fix old WebKit gradients convertor on rgba() colors.
* Allow to write old direction syntax in gradients.

### 20130906:
* Fix direction syntax in radial gradients.
* Don’t prefix IE filter with modern syntax.

### 20130911:
* Fix parsing property name with spaces.

### 20130919:
* Fix processing custom framework prefixes (by Johannes J. Schmidt).
* Concat outputs if several files compiled to one output.
* Decrease standalone build size by removing unnecessary Binary class.
* iOS 7 is moved to released versions.
* Clean up binary code (by Simon Lydell).

### 20130923:
* Firefox 24 is moved to released versions.

### 20131001:
* Add support for grab, grabbing, zoom-in and zoom-out cursor values.

### 20131006:
* Chrome 30 is moved to released versions.

### 20131007:
* Don’t add another prefixes in rule with prefixed selector.

### 20131009:
* Opera 17 is moved to released versions.

### 20131015:
* Fix converting multiple gradients to old webkit syntax (by Aleksei Androsov).

### 20131017:
* Fix @host at-rule parsing.

### 20131020:
* IE 11 and Andrid 4.3 is moved to released versions.
* Add Opera 18 data.
* Add @namespace support.
* Sort browser versions in data file.

### 20131029:
* Add Safari 6.1 data.
* Add fx alias for Firefox.

### 20131104:
* Update Android future version to 4.4.
* Google Chrome 32 added to future versions list.
* Firefox 25 now is actual version, 27 and 28 added to future versions.
* Browsers statistics are updated.

### 20131205:
* Google Chrome 33 added to future releases list.
* Google Chrome 31 moved to current releases list.

### 20131209:
* Fix Autoprefixer initializer on Heroku (by Jason Purcell).
* Use old webkit gradients for old iOS and Safari (by Chad von Nau).
* Fix direction conversion for old webkit gradients (by Chad von Nau).
* Update browsers popularity statistics.

### 20131213:
* Firefox ESR in default browsers was changed to 24 version.
* Firefox 26 was moved to current releases list.
* Firefox 28 was added to future releases list.

## 0.7 “We Do Not Sow”
* Add vendor prefixes to selectors.
* Add ::selection and ::placeholder selectors support.
* Allow to load support data from Can I Use pull requests.
* Remove deprecated API.

### 20130806:
* Add hyphens support.

### 20130807:
* Add tab-size support.
* Add :fullscreen support.

### 20130808:
* Allow to select browser versions by > and >= operator.
* Fix flex properties in transition.

### 20130810:
* Add Firefox 25 data.

### 20130824:
* Add Chrome 31 and 30 data.
* Fix CSS comments parsing (by vladkens).

## 0.6 “As High As Honor”
* New faster API, which cache preprocessed data. Old API is deprecated.
* A lot of perfomance improvements.
* Add Opera 15 -webkit- prefix support.
* Update Chrome 29 and Safari 7 prefixes data.
* Add minor browsers in popularity select.
* Better syntax error messages.

### 20130721:
* Add Chrome 30 data.

### 20130728:
* Don’t remove non-standard -webkit-background-clip: text.
* Don’t remove IE hack on CSS parse.
* Fix loading into Rails without Sprockets.

### 20130729:
* Add Opera 16 data.
* Fix “Invalid range in character class” error on JRuby.

### 20130730:
* Fix correct clone comments inside keyframes (by Alexey Plutalov).
* Fix angle recalculation in gradients (by Roman Komarov).

### 20130731:
* Add border-image support.

## 0.5 “Ours is the Fury”
* Rewrite Autoprefixer to be more flexible.
* Use css, instead of Rework, to fix CSS parsing errors faster.
* Fix a lot of CSS parsing errors.
* Fix sass-rails 4.0.0.rc2 compatibility.

### 20130616:
* More useful message for CSS parsing errors.
* Remove old WebKit gradient syntax.
* Fix parsing error on comment with braces.

### 20130617:
* Remove old Mozilla border-radius.
* Don’t prefix old IE filter.
* Remove old background-clip, background-size and background-origin prefixes.
* Speed up regexps in values.
* Allow to hack property declarations.

### 20130625:
* Convert flexbox properties to 2009 and 2012 specifications.
* Add support for sass-rails 4 final.

### 20130626:
* Add Firefox 24 data.
* Add prefixes for font-feature-settings.

### 20130629:
* Fix convert flex properties to old box-flex.
* Fix Sinatra (sprockets-sass) suuport.

## 0.4 “Winter Is Coming”
* Remove outdated prefixes.
* Add border-radius and box-shadow properties to database.
* Change degrees in webkit gradients.

### 20130515:
* Add old syntax in gradient direction.
* Add old syntax for display: flex.
* Update browser global usage statistics.

### 20130521:
* Add Firefox 23 data.
* Update css-parse to fix @-moz-document issue.

### 20130523:
* Update Rework’s libraries to fix @page statement.

### 20130524:
* Add Chrome 29 data.

### 20130527:
* Fix new css-stringify issue.

### 20130528:
* Fix compatibilty with Rework from git master.
* Add minor browsers to data, which can be selected only directly.

### 20130530:
* Add Opera 15 and iOS 6.1 data.
* Fix iOS versions in properties and values data.

### 20130603:
* Use latest Rework 0.15 with a lot of CSS parsing fixes.
* Update browsers usage statistics.

## 0.3 “Growing Strong”
* Use own filters instead of Rework’s `prefix` and `prefixValue`.
* Smarter value prefixer without false match “order” in “border”.
* 40% faster.
* Don’t add unnecessary properties instead of Rework’s `prefixValue`.
* Don’t change properties order.
* Sort properties and values in inspect output.

### 20130424:
* Fix value override in prefixer.

### 20130427:
* Prefix several same values in one property.

### 20130502:
* Don’t add -webkit- prefix to IE filter.
* Don’t duplicate already prefixed rules.

## 0.2 “Hear Me Roar!”
* Update parse libraries.
* Add inspect method and rake tast.

## 0.1 “Fire and Blood”
* Initial release.
