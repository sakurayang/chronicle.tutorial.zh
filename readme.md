# chronicle 教程

init

```sh
shiroa init --dest-dir ../dist -w . ./src/
```

build

```sh
shiroa build -w . -d ../dist --font-path ./fonts ./src/
```

complie

```sh
typst compile --root . --font-path ./fonts ./src/ebook.typ
```
