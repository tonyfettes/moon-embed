///|
test "name derivation" {
  inspect(derive_name("My-File.txt", false), content="my_file")
  inspect(derive_name("my-file.txt", true), content="MyFile")
  inspect(derive_name("123.bin", true), content="Embed123")
}

///|
test "name validation" {
  inspect(is_valid_name("my_file", false), content="true")
  inspect(is_valid_name("Bad-Name", false), content="false")
  inspect(is_valid_name("MyConst", true), content="true")
  inspect(is_valid_name("badName", true), content="false")
}

///|
test "render text" {
  let out = render_text("my_file", false, false, "Hello\nWorld")
  inspect(
    out,
    content=(
      #|///|
      #|let my_file : String =
      #|  #|Hello
      #|  #|World
      #|
    ),
  )
}

///|
test "render bytes" {
  let bytes : Bytes = [0x00, 0x01, 0xff]
  let out = render_bytes("data", false, false, bytes)
  inspect(
    out,
    content=(
      #|///|
      #|let data : Bytes =
      #|  [
      #|    0x00, 0x01, 0xff
      #|  ]
      #|
    ),
  )
}
