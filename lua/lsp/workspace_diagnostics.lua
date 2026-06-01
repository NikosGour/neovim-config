return {
  on_attach = function(client, bufnr)
    -- some clients support workspace diagnostics natively
    if client:supports_method("workspace/diagnostic", bufnr) then
      vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
    else
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end
  end
}
