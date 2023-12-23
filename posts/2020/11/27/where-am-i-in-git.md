<!--
.. title: Where am I (in git)?
.. slug: where-am-i
.. date: 2020-11-27 11:14:08 UTC
.. tags: linux, git, bash, programming
.. category:
.. link:
.. description:
.. type: text
-->

I recently started using ``git`` and [Github](https://github.com/simoninireland/)
in a more serious way than I've done in the past -- and promptly
started getting horrendously lost in the process.

<!-- TEASER_END -->

One developer kindly published
[a very detailed workflow](https://daniel.haxx.se/blog/2020/11/09/this-is-how-i-git/)
with suggestions on how to manage an open-source project's repo -- a
far more popular and complex project than any of mine -- and I adopted
a lot of his techniques.

The issue this gave rise to, though, was the more frequent and complex
use of branches. It makes sense to keep the "master" branch holding
the latest stable release -- all committed, tested, and working -- and
to do development on side branches that then get pulled or merged for
the next release. And I found myself getting lost more and more often,
forgetting which branch, dub-directory, and even project i was working
in.

Fortunately there was a solution in the same post: a modified ``bash``
prompt that shows the information. The version presented didn't quite
work for me, as I'm not solely a developer and so needed a prompt
that works *outside* ``git`` repos as well as *inside* them. I
developed the following shell function for use in my ``~/.bashrc``
configuration file:

```sh
# Show git project, branch, and prefix in command prompt when we're in a repo
brname () {
    ingit=`git rev-parse --is-inside-work-tree 2>&1 2>/dev/null`
    if [ "$ingit" == "true" ]; then
        gitdir=$(git rev-parse --show-toplevel)
        prompt=$(basename $gitdir)
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ "$branch" != "master" ]; then
            prompt="$prompt:$branch"
        fi
        subdir=$(git rev-parse --show-prefix)
        if [ -n "$subdir" ]; then
            prompt="$prompt $subdir"
        fi
        echo "[$prompt]"
    else
        echo "simon"
    fi
}
export PS1='$(brname)> '
```

Inside a repo this changes the ``bash`` prompt to show the project
name, branch, and prefix path within the repo. Outside a repo, it
just shows my name.
