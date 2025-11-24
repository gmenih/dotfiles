; extends

(call_expression
  function: (member_expression) @_fn
  (#match? @_fn "queryRaw|executeRaw|executeRawUnsafe")
  arguments: (template_string) @injection.content
  (#set! injection.language "sql")
  (#set! injection.include-children))
