///|
async fn main {
  try {
    let config = parse_args(@env.args())
    let data = @fs.read_file(config.input)
    let output = if config.is_binary {
      let bytes = data.binary()
      render_bytes(config.name, config.is_pub, config.is_const, bytes)
    } else {
      let text = data.text()
      render_text(config.name, config.is_pub, config.is_const, text)
    }
    @fs.write_file(config.output, output, create=0o644, truncate=true)
  } catch {
    CliError::Usage(msg) =>
      if msg is "" {
        println(usage())
      } else {
        println("\{msg}\n\n\{usage()}")
      }
    err => raise err
  }
}
