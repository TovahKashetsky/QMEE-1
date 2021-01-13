## Biology 708

The web site for Biology 708. The user-friendly view is [here](https://mac-theobio.github.io/QMEE/index.html).

## Workflow

__Under construction__

Directories with course content:
* <repo>/ contains the index document for the website
* admin contains administrative materials
* topics contains an overview page for each topic (roughly a week (or optional week) of the course
* lectures contains lecture material
* tips contains additional material from us

All of these directories follow the same rules to farm out material to corresponding subdirectories of docs/ which is where the github.io pages are served.

Some make rules:
* update_all is meant to remake the site
* push_all should push the main directory and all of the active subdirectories
* local_site opens a local-file-based version of the site
* old_site opens a local-file-based version of the 2019 site from the gh-pages directory

Here are some other directories that we currently have:

* data/
* figure/
* html/
* makestuff/
* oldSource/
* pix/
* topics/

Here is a directory we should have (but we may want to think carefully about how to make things there):

* lectures/
