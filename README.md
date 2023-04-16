# Dead simple SSG for dual-hosting on Gemini and the Web

[Demo hosted on Cloudflare Pages](https://ssg-1cm.pages.dev/)

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

Place your Gemtext blog entries in `gmi/blog` and run build.sh to generate the Gemini index and HTML pages. Put images and other files into `gmi/res`.

You can then point your Gemini server to the `gmi` directory, and your Web server to the `dist` directory.

## Setup with Git and Cloudflare Pages

Git works nicely as a way to track changes and synchronize them with your servers.

Start by initializing a new Git repo in the project directory. Make sure to use LFS to track `gmi/res/*`. Now you can customize the configuration and commit the changes.

Add the repo to GitHub or GitLab. Once that's done, go to the Cloudflare dashboard and click on Pages in the sidebar. Click "Create a project" and then "Connect to Git". You will be prompted to log into GitHub or GitLab and select a repo. Finally set the build command to `./build.sh` and the output directory to `dist`, then click "Save and deploy".

You can then verify that the site is working with the defualt domain that Cloudflare gives you (ending in `pages.dev`). If it's working properly, you can then go to "Custom domains" to link a domain added to your account with your website.

After that, set up a Gemini server any way you want. SourceHut apparently provides free static Gemini hosting, but I was too lazy to get it set up. I'm currently running Agate on my own server with a cron job that runs `git pull` on the repo every few minutes.
