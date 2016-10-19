iXu — Inform 7 Extensions Updater
=================================

>   WARNING: This application was designed for older versions of Inform7
>   (\<6L02), predating the introduction of the **public library** of extensions
>   feature!

>   Read carefully before using, to avoid overwriting your installed extensions.

TOC
---

-   [Introduction](#introduction)

-   [READ BEFORE EXECUTING!](#read-before-executing)

-   [Pre-built Binaries](#pre-built-binaries)

-   [Building iXu From Source](#building-ixu-from-source)

-   [Repository Contents](#repository-contents)

-   [Why iXu?](#why-ixu)

-   [The post-6L02 I7 Era](#the-post-6l02-i7-era)

-   [Usage](#usage)

-   [How iXu Works](#how-ixu-works)

-   [iXu’s Present-Day Uses…](#ixus-present-day-uses)

    -   [Working With Inform7 pre-6L02](#working-with-inform7-pre-6l02)

    -   [Tweaking iXu 1: Disable Writing to I7 Extensions
        Folder](#tweaking-ixu-1-disable-writing-to-i7-extensions-folder)

    -   [Tweaking iXu 2: Pointing It to Public
        Library](#tweaking-ixu-2-pointing-it-to-public-library)

-   [Latest Version](#latest-version)

-   [End of Development Notice](#end-of-development-notice)

-   [Contributing](#contributing)

Introduction
------------

iXu (Inform Extensions Updater) was a free stand-alone application for updating
Inform7 (pre-6L02) extensions under Microsoft Windows. It can still be used with
Inform7 pre-6L02 releases.

iXu was created by Tristano Ajmone in September 2010 using [AutoIt
Script](https://www.autoitscript.com).

Its now being released into **public domain**
([http://unlicense.org](http://unlicense.org/)) — see [LICENSE file](LICENSE)
for more details.

READ BEFORE EXECUTING!
----------------------

**ON FIRST RUN IXU WILL OVERWRITE ALL THE EXTENSIONS CONTAINED IN INFORM 7
EXTENSIONS FOLDER!!!**

That is: it will download every extension that is available on Inform7.com’s
extensions RSS page, and copy it to I7 extensions folder, overwriting them
without asking confirmation. This means that any extensions coming from sources
other than Inform7.com should not be at risk of being overwritten, still …

**BEFORE LAUNCHING IXU UPDATE MAKE A COPY OF YOUR INFORM 7 EXTENSIONS FOLDER!**

If by any chance you have manually changed some third pary extensions, and the
extension gets overwritten by iXu download, you’d lose your changes.

Pre-built Binaries
------------------

Pre-built Win x32 binaries are available for download under releases:

-   [https://github.com/tajmone/iXu/releases/latest](https://github.com/tajmone/iXu)

Building iXu From Source
------------------------

Building requires [AutoIt
v3.3.6.0](https://www.autoitscript.com/autoit3/files/archive/autoit/) (later
versions might not work without code adaptations):

-   [autoit-v3.3.6.0-setup.exe](https://www.autoitscript.com/autoit3/files/archive/autoit/autoit-v3.3.6.0-setup.exe)
    (installer — direct link)

-   [autoit-v3.3.6.0-sfx.exe](https://www.autoitscript.com/autoit3/files/archive/autoit/autoit-v3.3.6.0-sfx.exe)
    (Self Extracting Archive — direct link)

Repository Contents
-------------------

The iXu repository contains the following folders:

-   `/src/` — the AutoIt Script source code of iXu, plus the “iXu User Guide” in
    PDF.

-   `/src/INCLUDES/` — additional resources needed at compilation-time for
    inclusion into the final binary executable (GUI graphics and HTML
    templates).

-   `/iXu 3D Box/` — graphic files and template for the 3D product-box
    presentation image of iXu (includes also Photoshop and BoxShot 3D files).

-   `/iXu GUI/` — graphic source files for iXu’s GUI graphic resources.

-   `/iXu Logo/` — iXu’s Logo design, vector format (PSD and AI).

-   `/iXu User Guide/` — the userguide in MS Word source file.

Each folder contains a `README.md` file with more details.

Why iXu?
--------

Before the Inform 7 [6L02 release](http://inform7.com/download/release/6L02/)
(April 2014) extensions had to be manually downloaded (and updated) from
Inform7.com’s extensions page:

-   <http://inform7.com/write/extensions/>

From release 6L02 onward, I7 user interface includes a Public Library extensions
panel, which allows to download and update extensions from within the
application.

iXu was intended as a tool for those who’d like to have on their harddisk a copy
of all the extensions available at Inform7.com’s extensions page.

Another advantage of using iXu was that, when it updated an extension, it kept
date-stamped copies of previous versions; making it easy to revert to a given
version of any extension if required for compatibility issues. One of the
shortcomings of Inform 7 website’s extension page was that it provided only the
latest version of extensions.

iXu still works today, because the Inform7.com’s extensions page is still active
— but these extension are no longer intended for the latest versions of I7!

The post-6L02 I7 Era
--------------------

Since Inform 7 introduced the public library feature ([6L02
release](http://inform7.com/download/release/6L02/), April 2014), iXu’s *raison
d’être* has been exhausted. But iXu could still be useful, with some minor
tweaks on how it works.

Now the Inform 7 app fecthes its public library extensions from:

-   <http://www.emshort.com/pl/payloads/>

iXu still fetches extension from Inform7.com’s extensions page (via [RSS
Feed](http://inform7.com/extensions/I7ExtensionsRSS.xml)):

-   <http://inform7.com/write/extensions/>

So, there are effectively two official I7-extensions pools — something rather
confusing. Inform7.com’s extensions page is now considered the “older extensions
pool”, which is kept for good reasons:

1.  In 2014 Inform7 has undergone some major updates braking backward
    compatibility, thus rendering many extensions obsolete.

2.  Some people might need access to pre-6L02 extensions because they need some
    extensions which have not yet been update to newer versions of I7, and
    prefer to work with an older version of Inform7 instead of loosing the
    advantages of such extensions.

3.  Someone wants to update an old extension to the lastest version Inform7, so
    that i can be included among the **public library** extensions.

For more information on this topic, visit these links:

-   [http://www.intfiction.org/forum/viewtopic.php?f=7&t=17890](http://www.intfiction.org/forum/viewtopic.php?f=7&t=17890)

-   [https://emshort.wordpress.com/2015/04/15/inform-extension-updating/](https://emshort.wordpress.com/2015/04/15/inform-extension-updating/)

Usage
-----

iXu is very simple to use. The user is presented with an interface with a single
button START. Pressing the button will start the extensions update process.

When the update is finished the button will read VIEW LOG and can be pressed to
view the log file containing the details of the extensions downloaded (if any)
and the failed downloads (if any).

It’s as simple as that.

How iXu Works
-------------

The way iXu works is very simple and it takes as a reference for decisions two
folders which are located inside the iXu program folder: “`Extensions Archive`”
and “`Extensions Download`”. These folders will be created at first execution of
iXu.

The operative scheme of iXu is as follows:

-   It connects to Inform7.com’s Extension RSS page and extracts a list of all
    the available extensions.

-   Running through the list it checks for each extension if iXu’s “`Extensions
    Archive`” folder contains a copy of the extension matching its publication
    date, if not it downloads it in the “`Extensions Download`” folder
    (overwriting previous versions of it, if any), **then copies the extension
    to Inform 7 extensions folder overwriting any existing version**. Finally,
    it creates a copy of the extension in the “`Extensions Archive`” folder
    (adding at the beginning of the filename the author’s name, and at the end
    of the filename a timestamp with the release date).

-   After processing all the extensions in the list, iXu creates an updated
    **Extensions List HTML page** contaning the description of all downloaded
    extensions (latest version only, no duplicates) as presented on Inform7.com
    website.

-   A **log file** is then rendered available to the user through the
    interface’s only button. The log contains a list of the downloaded
    extensions (if any) and the failed downloads (if any).

iXu therefore bases his decision to download an extension solely on the presence
or absence of a copy of the give extension in the “`Extensions Archive`” folder.
This means that if you delete any copies of an extensions in that folder you’ll
force iXu to reload that extension on next execution. The Archive folder doesn’t
contain any subfolders: the author’s name is prefixed to the extensions’name,
the date of the extensions’s publication is appended to it. If for any reasons
you need an older version of an extension, this is the folder where you should
look for it.

It is not clear to me if Inform7.com RSS extensions page lists older versions of
an extension or only the latest releases of it, but as extensions do get updated
iXu will keep in his local folder copies of the older editions downloaded of any
extension. This might come handy in case you’d need an older version of an
extension for any reason.

The “`Extensions Download`” folder only contains the updated version of any
extension (unlike the Archive folder which contains all available versions of
any extension). Each extension is placed inside a folder with it’s author’s
name, mirroring the system used in Inform 7 actual extensions folder. The
purpose of this folder is to keep a copy of all extensions downloaded by iXu.
Extensions inside this folder are always the latest release. Deleting extensions
inside this folder has no effect on iXu’s behaviour, but keep in mind that iXu
will not redownload them.

Every extension downloaded will have it’s “creation” and “last modified” date
set to the date of publication on Inform 7 RSS page.

The log file is deleted and replace at each execution of iXu, so if for any
reason you want to keep a copy of your log files rename them after each
execution.

If iXu doesn’t find Inform 7 extensions folder (it assumes it will be:
`MyDocuments/Inform/Extensions`) it will just download to its “`Extensions
Download`” folder and you’ll have to “install” extensions manually by copying
the contents of “`Extensions Download`” folder to Inform 7 extensions folder.

iXu’s Present-Day Uses…
-----------------------

Let’s see if iXu can still be employed — either as it is, or by tweaking its
source code.

### Working With Inform7 pre-6L02

iXu can still be used (out of the box) by anyone wishing to work with pre-6L02
Inform7.

Since there are still lots of great extensions which have not been updated to
work with post-6L02 Inform7, there are still as many good reasons to opt for
working with older versions of Inform7. In this case, iXu is a precious tool
that automates extensions downloading and updating, and produces neat HTML
reports on the status of the extensions.

### Tweaking iXu 1: Disable Writing to I7 Extensions Folder

iXu could be tweaked so it doesn’t copy any extensions to Inform7 extensions
folders, only saving in its local “`Extensions Archive`” folder any newer
extensions found on Inform7.com — this only requires to comment out the lines of
code which handle copying the downloaded extensions to I7 extensions folder
(lines 424-428):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Copy to Inform 7 Extensions Folder
if $extensions_folder_exists Then
    DirCreate ($I7_ExtensionsFolder & "\" & $ItemAuthorCleaned)
    FileCopy ($FileToSave, $I7_ExtensionsFolder & "\" & $ItemAuthorCleaned  & "\" & $ItemFileNameCleaned & ".i7x",1)
EndIf
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

### Tweaking iXu 2: Pointing It to Public Library

I’m not sure if this would be of any use, but iXu could be tweaked to point to
the **public library** instead of Inform7.com:

-   <http://www.emshort.com/pl/payloads/>

Since I7 already handles this from within the user interface, it might be quite
useless — unless intended as a tool for keeping a date-stamped archive of all
extensions releases.

Anyhow, this would require some major tweaking of iXu’s source, because iXu
relies on Inform7.com xml RSS feed — whereas the payloads page doesn’t provide
RSS feeds.

Latest Version
--------------

iXu last update was version 2.4 (beta), dating back September 2010.

Even though still tagged as Beta release, iXu has been used extensively without
problem reports; so it can be considered stable.

Version Beta 2.4 solved an issue that caused iXu to crash with systems other
than Windows XP SP3. Now it should work with all Windows editions from XP
onward.

End of Development Notice
-------------------------

I will no longer maintain iXu, and it has been too many years since I’ve laid my
hands on it source code. I’m releasing its source so that anyone who might feel
to take on the project can do so, but I won’t be following its developement any
further.

Contributing
------------

If you want to contribute to iXu’s developement, just fork it and carry on from
there — but don’t open issues on this repo or contact me expecting help.

iXu is now public domain, so feel free of revamping it however you wish —
including, changing its name and logo. You’re under no obligations of mentioning
the original project and author, but mentionings would be appreciated.

 
-
