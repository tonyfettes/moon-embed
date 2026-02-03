///|
struct Config {
  input : String
  output : String
  name : String
  is_pub : Bool
  is_const : Bool
  is_binary : Bool
}

///|
pub(all) suberror CliError {
  Usage(String)
} derive(Show, Eq)

///|
fn usage() -> String {
  (
    #|Usage: moon-embed <input> -o <output> [options]
    #|
    #|Options:
    #|  -o, --output <path>   Output .mbt file (required)
    #|  --name <ident>        Binding name (default: derived from input)
    #|  --binary              Embed as Bytes (default: text)
    #|  --pub                 Use pub binding
    #|  --const               Use const binding (name default UpperCamel)
    #|  --help                Show this help
    #|
  )
}

///|

///|
fn parse_args(args : Array[String]) -> Config raise CliError {
  let mut input : String? = None
  let mut output : String? = None
  let mut name : String? = None
  let mut is_pub = false
  let mut is_const = false
  let mut is_binary = false
  let mut help = false

  let len = args.length()
  for i = 1; i < len; {
    let arg = args[i]
    if arg is "--help" {
      help = true
      continue i + 1
    }
    if arg is "--pub" {
      is_pub = true
      continue i + 1
    }
    if arg is "--const" {
      is_const = true
      continue i + 1
    }
    if arg is "--binary" {
      is_binary = true
      continue i + 1
    }
    if arg is "-o" || arg is "--output" {
      if i + 1 >= len {
        raise CliError::Usage("missing value for \{arg}")
      }
      output = Some(args[i + 1])
      continue i + 2
    }
    if arg is "--name" {
      if i + 1 >= len {
        raise CliError::Usage("missing value for --name")
      }
      name = Some(args[i + 1])
      continue i + 2
    }
    if arg is [.. "-", ..] {
      raise CliError::Usage("unknown option: \{arg}")
    }
    match input {
      None => input = Some(arg)
      Some(_) => raise CliError::Usage("too many input files")
    }
    continue i + 1
  } else {

  }

  if help {
    raise CliError::Usage("")
  }

  let input_val = match input {
    Some(val) => val
    None => raise CliError::Usage("missing input file")
  }
  let output_val = match output {
    Some(val) => val
    None => raise CliError::Usage("missing -o/--output")
  }
  let name_val = match name {
    Some(val) => val
    None => derive_name(input_val, is_const)
  }
  if !is_valid_name(name_val, is_const) {
    let kind = if is_const { "UpperCamel" } else { "lower_snake" }
    raise CliError::Usage("invalid name: \{name_val} (expected \{kind})")
  }

  Config::{
    input: input_val,
    output: output_val,
    name: name_val,
    is_pub,
    is_const,
    is_binary,
  }
}
