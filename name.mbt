///|
fn stem_from_path(path : String) -> String {
  let p : @path.Path = @path.Path(path)
  let base = p.basename()
  let stem_view = lexmatch base {
    ((".*[.]" as stem_prefix) ("[^.]*" as _ext)) =>
      match stem_prefix {
        [.. stem, '.'] => stem
        _ => stem_prefix
      }
    _ => base
  }
  let stem = stem_view.to_string()
  if stem is "" {
    base.to_string()
  } else {
    stem
  }
}

///|
fn to_lower_snake(stem : String) -> String {
  let sb = StringBuilder::new()
  let mut prev_underscore = false
  for c in stem {
    if c.is_ascii_alphabetic() {
      sb.write_char(c.to_ascii_lowercase())
      prev_underscore = false
    } else if c.is_ascii_digit() {
      sb.write_char(c)
      prev_underscore = false
    } else if !prev_underscore {
      sb.write_char('_')
      prev_underscore = true
    }
  }
  let raw = sb.to_string()
  let trimmed = raw.trim(chars="_").to_string()
  if trimmed is "" {
    "embed"
  } else {
    let first = trimmed.get_char(0)
    if first is Some(c) && c.is_ascii_alphabetic() {
      trimmed
    } else {
      "embed_\{trimmed}"
    }
  }
}

///|
fn to_upper_camel(stem : String) -> String {
  let snake = to_lower_snake(stem)
  let sb = StringBuilder::new()
  for seg in snake.split("_") {
    let part = seg.to_string()
    if part is "" {
      continue
    }
    let mut first_done = false
    for c in part {
      if !first_done {
        sb.write_char(c.to_ascii_uppercase())
        first_done = true
      } else {
        sb.write_char(c)
      }
    }
  }
  let raw = sb.to_string()
  if raw is "" {
    "Embed"
  } else {
    let first = raw.get_char(0)
    if first is Some(c) && c.is_ascii_alphabetic() {
      raw
    } else {
      "Embed\{raw}"
    }
  }
}

///|
fn derive_name(path : String, is_const : Bool) -> String {
  let stem = stem_from_path(path)
  if is_const {
    to_upper_camel(stem)
  } else {
    to_lower_snake(stem)
  }
}

///|
fn is_valid_lower_snake(name : String) -> Bool {
  let mut i = 0
  for c in name {
    if i is 0 {
      if !c.is_ascii_lowercase() {
        return false
      }
    } else if !(c.is_ascii_lowercase() || c.is_ascii_digit() || c == '_') {
      return false
    }
    i = i + 1
  }
  i > 0
}

///|
fn is_valid_upper_camel(name : String) -> Bool {
  let mut i = 0
  for c in name {
    if i is 0 {
      if !c.is_ascii_uppercase() {
        return false
      }
    } else if !(c.is_ascii_alphabetic() || c.is_ascii_digit()) {
      return false
    }
    i = i + 1
  }
  i > 0
}

///|
fn is_valid_name(name : String, is_const : Bool) -> Bool {
  if is_const {
    is_valid_upper_camel(name)
  } else {
    is_valid_lower_snake(name)
  }
}
