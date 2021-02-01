local lean = {lsp = {}, snippets = {}}

function lean.setup(opts)
  opts = opts or {}

  local snippets = opts.snippets or {}
  if snippets.enable ~= false then lean.snippets.enable(snippets) end

  local lsp = opts.lsp or {}
  if lsp.enable ~= false then lean.lsp.enable(lsp) end
end

function lean.lsp.enable(opts)
  require('lspconfig').leanls.setup(opts)
end

function lean.snippets.enable(opts)
  local this_file = debug.getinfo(2, "S").source:sub(2)
  local base_directory = vim.fn.fnamemodify(this_file, ":h:h:h")
  local abbreviations = base_directory .. '/vscode-lean/abbreviations.json'

  local lean_snippets = {}

  for from, to in pairs(vim.fn.json_decode(vim.fn.readfile(abbreviations))) do
    lean_snippets["\\" .. from] = to
  end

  for from, to in pairs(opts.extra or {}) do
    lean_snippets["\\" .. from] = to
  end

  local snippets = require('snippets')
  local all_snippets = snippets.snippets or {}

  all_snippets.lean = lean_snippets
  snippets.snippets = all_snippets
end

return lean
