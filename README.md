# moon-embed

Embed files into MoonBit source as `String` or `Bytes` bindings. The tool reads an input file and emits a `.mbt` file that you can import in your package.

## Usage

```text
Usage: moon-embed <input> -o <output> [options]

Options:
  -o, --output <path>   Output .mbt file (required)
  --name <ident>        Binding name (default: derived from input)
  --binary              Embed as Bytes (default: text)
  --pub                 Use pub binding
  --const               Use const binding (name default UpperCamel)
  --help                Show this help
```

## Examples

Run from the module root using `moon`:

```bash
moon run . -- assets/logo.txt -o assets/logo_embed.mbt
```

Embed binary data as `Bytes` and export it:

```bash
moon run . -- assets/logo.png -o assets/logo_png.mbt --binary --pub
```

Provide a custom name and emit a `const` binding:

```bash
moon run . -- assets/config.json -o assets/config_embed.mbt --name ConfigJson --const
```

## Output Format

The generated `.mbt` file contains a single top-level binding:

- Text embeds use MoonBit multiline strings with `#|` lines.
- Binary embeds use a `Bytes` array of hex literals.
- Each output starts with `///|` so the block can be parsed reliably by MoonBit tooling.

Example (text):

```mbt
///|
let my_file : String =
  #|Hello
  #|World
```

Example (bytes):

```mbt
///|
let data : Bytes =
  [
    0x00, 0x01, 0xff
  ]
```

## Name Derivation

If `--name` is not provided, the tool derives a name from the input filename:

- Default: lower\_snake (e.g. `my-file.txt` → `my_file`)
- With `--const`: UpperCamel (e.g. `my-file.txt` → `MyFile`)

## Development

Common commands:

```bash
moon check
moon test
```

## License

Apache-2.0. See `LICENSE`.
