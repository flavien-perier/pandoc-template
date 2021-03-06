![license](https://badgen.net/github/license/flavien-perier/pandoc-template)

# Pandoc Template

## Installation

- Debian

```sh
apt-get install -y pandoc pandoc-citeproc texlive-*
```

- Arch

```sh
pacman -Syyu pandoc pandoc-citeproc
pacman -Syyu `pacman -Ss texlive | cut -f 1 -d " " | grep -v "^$"`
```

## Usage

- Compile all Markdown files contained in the documents folder:

```sh
./build.sh
```

## References

- Compiler: [Pandoc](https://pandoc.org/)
- Pandoc template: [Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template)
- CSL: [Multiple Sclerosis Journal](https://github.com/citation-style-language/styles/blob/master/multiple-sclerosis-journal.csl)
