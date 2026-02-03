///|
fn render_text(
  name : String,
  is_pub : Bool,
  is_const : Bool,
  content : String,
) -> String {
  let lines : Array[String] = []
  lines.push("///|")
  lines.push(binding_line(name, "String", is_pub, is_const))
  for line in content.split("\n") {
    let line_str = line.to_string()
    lines.push("  #|\{line_str}")
  }
  lines.push("")
  lines.join("\n")
}
