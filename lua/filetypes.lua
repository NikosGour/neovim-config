vim.filetype.add({
  filename = {
    [".htmlhintrc"] = "json",
  },
  pattern = {
    [".*compose%.yaml"] = "dockercompose",
    [".*compose%.yml"] = "dockercompose",
  },
})
