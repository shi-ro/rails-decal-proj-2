# Sass [![Gem Version](https://badge.fury.io/rb/sass.png)](http://badge.fury.io/rb/sass) [![Inline docs](http://inch-ci.org/github/sass/sass.svg)](http://inch-ci.org/github/sass/sass)

**Sass makes CSS fun again**. Sass is an extension of CSS,
adding nested rules, variables, mixins, selector inheritance, and more.
It's translated to well-formatted, standard CSS
using the command line tool or a web-framework plugin.

Sass has two syntaxes. The new main syntax (as of Sass 3)
is known as "SCSS" (for "Sassy CSS"),
and is a superset of CSS's syntax.
This means that every valid CSS stylesheet is valid SCSS as well.
SCSS files use the extension `.scss`.

The second, older syntax is known as the indented syntax (or just "Sass").
Inspired by Haml's terseness, it's intended for people
who prefer conciseness over similarity to CSS.
Instead of brackets and semicolons,
it uses the indentation of lines to specify blocks.
Although no longer the primary syntax,
the indented syntax will continue to be supported.
Files in the indented syntax use the extension `.sass`.

## Using

Sass can be used from the command line
or as part of a web framework.
The first step is to install the gem:

    gem install sass

After you convert some CSS to Sass, you can run

    sass style.scss

to compile it back to CSS.
For more information on these commands, check out

    sass --help

To install Sass in Rails 2,
just add `config.gem "sass"` to `config/environment.rb`.
In Rails 3, add `gem "sass"` to your Gemfile instead.
`.sass` or `.scss` files should be placed in `public/stylesheets/sass`,
where they'll be automatically compiled
to corresponding CSS files in `public/stylesheets` when needed
(the Sass template directory is customizable...
see [the Sass reference](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#template_location-option) for details).

Sass can also be used with any Rack-enabled web framework.
To do so, just add

```ruby
require 'sass/plugin/rack'
use Sass::Plugin::Rack
```

to `config.ru`.
Then any Sass files in `public/stylesheets/sass`
will be compiled into CSS files in `public/stylesheets` on every request.

To use Sass programmatically,
check out the [YARD documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#using_sass).

## Formatting

Sass is an extension of CSS
that adds power and elegance to the basic language.
It allows you to use [variables][vars], [nested rules][nested],
[mixins][mixins], [inline imports][imports],
and more, all with a fully CSS-compatible syntax.
Sass helps keep large stylesheets well-organized,
and get small stylesheets up and running quickly,
particularly with the help of
[the Compass style library](http://compass-style.org).

[vars]:    http://sass-lang.com/documentation/file.SASS_REFERENCE.html#variables_
[nested]:  http://sass-lang.com/documentation/file.SASS_REFERENCE.html#nested_rules
[mixins]:  http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins
[imports]: http://sass-lang.com/documentation/file.SASS_REFERENCE.html#import

Sass has two syntaxes.
The one presented here, known as "SCSS" (for "Sassy CSS"),
is fully CSS-compatible.
The other (older) syntax, known as the indented syntax or just "Sass",
is whitespace-sensitive and indentation-based.
For more information, see the [reference documentation][syntax].

[syntax]: http://sass-lang.com/documentation/file.SASS_REFERENCE.html#syntax

To run the following examples and see the CSS they produce,
put them in a file called `test.scss` and run `sass test.scss`.

### Nesting

Sass avoids repetition by nesting selectors within one another.
The same thing works for properties.

```scss
table.hl {
  margin: 2em 0;
  td.ln { text-align: right; }
}

li {
  font: {
    family: serif;
    weight: bold;
    size: 1.2em;
  }
}
```

### Variables

Use the same color all over the place?
Need to do some math with height and width and text size?
Sass supports variables, math operations, and many useful functions.

```scss
$blue: #3bbfce;
$margin: 16px;

.content_navigation {
  border-color: $blue;
  color: darken($blue, 10%);
}

.border {
  padding: $margin / 2;
  margin: $margin / 2;
  border-color: $blue;
}
```

### Mixins

Even more powerful than variables,
mixins allow you to re-use whole chunks of CSS,
properties or selectors.
You can even give them arguments. 

```scss
@mixin table-scaffolding {
  th {
    text-align: center;
    font-weight: bold;
  }
  td, th { padding: 2px; }
}

@mixin left($dist) {
  float: left;
  margin-left: $dist;
}

#data {
  @include left(10px);
  @include table-scaffolding;
}
```

A comprehensive list of features is available
in the [Sass reference](http://sass-lang.com/documentation/file.SASS_REFERENCE.html).

## Executables

The Sass gem includes several executables that are useful
for dealing with Sass from the command line.

### `sass`

The `sass` executable transforms a source Sass file into CSS.
See `sass --help` for further information and options.

### `sass-convert`

The `sass-convert` executable converts between CSS, Sass, and SCSS.
When converting from CSS to Sass or SCSS,
nesting is applied where appropriate.
See `sass-convert --help` for further information and options.

### Running locally

To run the Sass executables from a source checkout instead of from rubygems:

```
$ cd <SASS_CHECKOUT_DIRECTORY>
$ bundle
$ bundle exec sass ...
$ bundle exec scss ...
$ bundle exec sass-convert ...
```

## Authors

Sass was envisioned by [Hampton Catlin](http://www.hamptoncatlin.com)
(@hcatlin). However, Hampton doesn't even know his way around the code anymore
and now occasionally consults on the language issues. Hampton lives in San
Francisco, California and works as VP of Technology
at [Moovweb](http://www.moovweb.com/).

[Natalie Weizenbaum](https://twitter.com/nex3) is the primary developer and architect of
Sass. Her hard work has kept the project alive by endlessly answering forum
posts, fixing bugs, refactoring, finding speed improvements, writing
documentation, implementing new features, and getting Hampton coffee (a fitting
task for a girl genius). Natalie lives in Seattle, Washington and works on
[Dart](http://dartlang.org) application libraries at Google.

[Chris Eppstein](http://acts-as-architect.blogspot.com) is a core contributor to
Sass and the creator of Compass, the first Sass-based framework. Chris focuses
on making Sass more powerful, easy to use, and on ways to speed its adoption
through the web development community. Chris lives in San Jose, California with
his wife and daughter. He is an Engineer for
[LinkedIn.com](http://linkedin.com), where one of his responsibilities is to
maintain Sass & Compass.

If you use this software, you must pay Hampton a compliment. And buy Natalie
some candy. Maybe pet a kitten. Yeah. Pet that kitty.

Beyond that, the implementation is licensed under the MIT License.
Okay, fine, I guess that means compliments aren't __required__.
