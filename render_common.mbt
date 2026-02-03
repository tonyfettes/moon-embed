///|
fn binding_line(
  name : String,
  type_name : String,
  is_pub : Bool,
  is_const : Bool,
) -> String {
  let sb = StringBuilder::new()
  if is_pub {
    sb.write_string("pub ")
  }
  if is_const {
    sb.write_string("const ")
  } else {
    sb.write_string("let ")
  }
  sb.write_string(name)
  sb.write_string(" : ")
  sb.write_string(type_name)
  sb.write_string(" =")
  sb.to_string()
}
