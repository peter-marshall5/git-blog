# Dead simple SSG for dual-hosting on Gemini and the Web

- Written in Bash - No dependencies other than coreutils.
- Converts entries written in Gemtext to HTML.
- Generates an index page for Gemini.
- Can be hosted on GitHub and Cloudflare Pages, and probably most other static hosts too.
- Comes with a cool minimalistic default theme (that I'm currently using on my blog)
- Default theme supports light and dark modes.
- Default theme is written in pure HTML and CSS - No JavaScript, anywhere.
- The homepage of the Web mirror gets a perfect Lighthouse score.
- Supports inline images (Generated when a URL points to a common image file extension.)
- It's extremely hackable - Feel free to go crazy with customization.

## Usage

Place your Gemtext blog entries in `gmi/blog` and run build.sh to generate the Gemini index and HTML pages.

You can then point your Gemini server to the `gmi` directory, and your Web server to the `dist` directory.
