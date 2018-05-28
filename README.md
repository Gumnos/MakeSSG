MakeSSG
=======

A Makefile-driven static site generator currently supporting Markdown
and HTML markup.  This uses the stock `make(1)` from OpenBSD and may
not be compatible with GNU `make`.

To create the initial directory structure, issue

    $ make dirs

This will create a `posts` directory and an `output` directory.

It also creates a sample `hello.md` post as a starting-point.

Once you have posts, simply invoke `make` to generate the output.

Create either raw HTML post content (`.html`) or Markdown (`.md`).

To create Markdown, you'll need
[` Markdown.pl`](http://daringfireball.net/projects/downloads/Markdown_1.0.1.zip)
(from https://daringfireball.net/projects/markdown/ )
unzipped in the project directory.

This is largely an experiment.
It's not fancy.
It doesn't do RSS yet
or create an index page
or tags
or pagination.
It's largely a slap-a-header-and-footer-around-content generator.

It should copy the directory structure so you can create categories
by creating sub-directories in the `posts/` directory.

Any non-`.html`, non-`.md` files get copied verbatim to the
`output/` folder so this creates assets (images, CSS, JS) if desired.

The header is stored in `_header.html`
and the footer stored unsurprisingly in `_footer.html`.
Modifying these allows inclusion of additional CSS, JavaScript,
meta information, etc.

Known Bugs
==========

If you have two posts with the same name but different extensions (e.g.
`hello.md` and `hello.html`) it will have issues.


Todo
====

- Generate an index page

- Create an RSS feed

- Handle tags and a tag-database generation scheme

- Create smarter HTML "title" elements
