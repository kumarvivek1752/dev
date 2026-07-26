return {
    'hat0uma/csvview.nvim',
    config = function()
        require('csvview').setup(
            {
                parser = {
                    --- minimum width of a column
                    --- @type integer
                    max_column_width = 5,
                },
                view = {
                    display_mode = "border"
                }
            }
        )
        vim.keymap.set("n", "<leader>cv", ":CsvViewToggle<CR>")
    end
}
