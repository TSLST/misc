---
Type: Doc
Use: README file for miscellaneous projets GitHub repository.
Tags: !!str "#readme #projects #github"
Creation: 2026-06-22
Update: 2026-07-02
Contributors: [神縁]
---

[Version en francais](LISEZMOI.md)

# Miscellaneous Projects
================================================================================

-------------------------
## Description
-------------------------

This repository is intended to display various snippets of code or work that I am currently working on and also describe their purpose and meanings in this very README introduction.

-------------------------
## Projects
-------------------------

---
### VBA Stringbuilder class
###

[Stringbuilder](cStringBuilder.cls)

This object is out of my usual library of functions. It is usually directly included in the library I developped as its use is really important in Access SQL manipulations for example.
Here I present a separated class, no error pile management and no usage of the *library* builtin functions to run it in singletons or to simplify it in any way.

#### Showing formatting guidelines 

I uploaded this here to display an idea of how I used to code in VBA and how I structured my classes.
There is more to say to this as the complete *library* I installed at the start of every project would have had extra error management with pilestack of function calls and line markers, unique exits and evolved garbage collectors...
I may release guidelines on VBA formatting and visually efficient hungarian notations. This feels not needed as the usage of XL and Access will be decreasing and hence the usage of VBA too. Open Source IDEs for libroffice and open office likes do not compete with the original VBA + MZTools3VBA.
There were already a few VBA limitations that were really annoying (Such as option base 1 not being applied everywhere once set for example: iirc arrays and api calls were not clearly using the option). The coder base 0 is really a coder gimmick that loses its sense in real thinking. It is only efficient to store ghost data such as object names, pointers and headers, things useful but not displayed.

#### Usability

This snippet proved tramendously useful in solving my first real job: cutting cost on loading of pages for users.<br>
The loading time was overly long for a wrong reason: concatenation of strings using the `&` operator. At every operation a new string is created and the memory allocation and garbage collection Times pile up with iterations.
Using `$mid` builtin function solves this problem really cleverly. Rather than create a string variable containing only the string to write, this create a much larger space ready to allocate more text by replacing blank characters and keeping track of where the actual string is located. Blank chars are left available at the very end for new concatenations. The size of the buffer (Leading string and tailing blanks) augments exponentially by doubling its size every time needed. So in the meantime of 10 `&` concatenations (including initial string) you pretty much can concatenate up to $34*2^9=17,408$ characters, 34 being the number of characters for the initial size of the buffer.

#### Improvement

As I was working on bitmask computations accelerations, I found a little snippet of code allowing to ameliorate the calculation of powers of 2. Rather than let the computer perform a brute force computation (Which is pretty much an iteration of multiplications), it is possible to use the bit form and simply write a 1 one level upper than the leading one and follow this by zeros...
Instant power of 2 for optimization.

#### Study

This code is interesting for two reasons:
- First the array size expansion technique with buffer increments by power of two which will save a tremendous amount of computation in other areas.
- The bitmask power of two computations is also a clever trick to win some computation efficiency.

---
### TSLST
###

TSLST stands for **Traced Source Licensing Standard Terminology**. As agentic parsing and developping takes more and more importance in today's web expansion, MIT license was missing two features that this licensing intends to solve:
- Ensuring **accountability** of agents: IA agents are in their infancy, whatever they produce are anyone's responsability.
- **Tracability** of ideas: crediting the source both in **legal** ways and as a **community standard** may allow to map **influences** of positive directions in development, may give a bit of informal **credit** to conceptors and link back to similar implementations. This is hard to visualize for now but will only gradually expand over Time as data is processed at larger scale.

Spiritually I am all in favor of shared commons and knowledge, TSLST is an attempt at keeping permissivemess and open sourcing while ensuring good practices and legal claims in case of improper usage. TSLST can only be used at projects that separate enough from the initial influence to void the previous MIT licenses, it will mostly be used on things that I developped from scratch.

[LICENSE](manifesto_tslst)

---
### Symlink Commit
###

I tend to use symlinks to access the same file from different endpoints, especially useful if the file is used within many projects and it helps centralize documents.
The problem is that git does not manage the symlinks properly and only uploads a symbolic link to GitHub rather than the original file.
I made a short bash script to resolve this issue elegantly.
In `.bash_aliases`:
```bash
alias gsc='git_symlink_commit.sh'
```
Usage:
```bash
cd /git/folder
gsc "COMMIT_MESSAGE"
```

[Symlink commits](git_symlink_commit.sh)

-------------------------
## Incoming
-------------------------

I might post a prd or two, some python scripts that I use these days while I am working on a complete personal toolkit library, harness scripts for local llm on old hardware and 0 cost, papers on different subjects I work on $-$ such as applying AI to simulated environment: a 3D simulated env like Quake 3 would be the next level of AI to deploy as the fuzzy logic bots are now outdated (But first I need to master its source code and install stereography).

***