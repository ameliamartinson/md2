### MD2

This is supposed to be an implementation of the md2 hashing algorithm in Rust.

I tried to follow the rf1319 pseudocode as closely as possible.

See: [https://www.rfc-editor.org/rfc/pdfrfc/rfc1319.txt.pdf](https://www.rfc-editor.org/rfc/pdfrfc/rfc1319.txt.pdf)
and [https://www.rfc-editor.org/errata/rfc1319](https://www.rfc-editor.org/errata/rfc1319)

I've added a corrected version of the above to this repo.

```sh
cargo build
echo "hello, world" | ./target/debug/md2
```

