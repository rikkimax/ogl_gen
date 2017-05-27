# OpenGL binding generator (with docs)

## How to use:

```sh
dub run ogl_gen -- --gen-d=<filename> --gen-d-module=<package.module> --load-core-4.5 --load-core-3 --load-core-2 --load-spec
```

Add ``--gen-d-wrapperName=<name>`` if you want it wrapped in a struct.

Add ``--gen-d-static`` if you want a static binding, otherwise it will be dynamic.