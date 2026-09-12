local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("iferr", {
    t({ "if err != nil {", "\treturn " }),
    i(1, "nil"),
    t({ ", err", "}" }),
  }),

  s("iferrlog", {
    t({ "if err != nil {", '\tlog.Error("' }),
    i(1, "functionName"),
    t({ ': %v", err)', "\t" }),
    i(2),
    t({ "", "}" }),
  }),
}
