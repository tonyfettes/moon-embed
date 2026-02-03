///|
fn byte_hex(b : Byte) -> String {
  let hex = b.to_hex()
  if hex.length() == 1 {
    "0x0\{hex}"
  } else {
    "0x\{hex}"
  }
}

///|
fn render_bytes(
  name : String,
  is_pub : Bool,
  is_const : Bool,
  bytes : Bytes,
) -> String {
  let lines : Array[String] = []
  lines.push("///|")
  lines.push(binding_line(name, "Bytes", is_pub, is_const))
  lines.push("  [")
  let total = bytes.length()
  if total > 0 {
    let mut line_sb = StringBuilder::new()
    let mut line_count = 0
    for i, b in bytes {
      if line_count == 0 {
        line_sb.write_string("    ")
      } else {
        line_sb.write_string(", ")
      }
      line_sb.write_string(byte_hex(b))
      line_count = line_count + 1
      let is_last = i == total - 1
      let line_full = line_count == 12
      if line_full || is_last {
        if !is_last {
          line_sb.write_string(",")
        }
        lines.push(line_sb.to_string())
        line_sb = StringBuilder::new()
        line_count = 0
      }
    }
  }
  lines.push("  ]")
  lines.push("")
  lines.join("\n")
}
