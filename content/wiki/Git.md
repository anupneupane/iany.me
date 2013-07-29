---
updated_at: <2013-07-27 15:48:34>
created_at: <2011-12-03 03:40:47>
title: Git
tags: [git, github]
---

## Git Tips ##

-   Get master, but use current branch as final state.

        git merge master -s ours

-   Patient merge, better lines matching

        git merge master -s recursive -X patience

-   Strip spaces from file, and do spaces check

        git stripspace
        git diff --check

-   Incremental replacement

        git stash
        ./run-script
        git diff stash@{0}   
 
-   Diff unstaged changes

        git diff --cached
    
-   Abort merge with conflict

        git merge --abort

-   Shore ignored thins

        git status --ignored

## Github Tips

-   Fetch pulls

        git fetch origin pull/:id/head:localname
