return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local default_opts = { noremap = true }

            -- harpoon
            telescope.load_extension("harpoon")

            -- config
            telescope.setup({
                defaults = { file_ignore_patterns = { "node_modules", ".venv" } },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--iglob",
                            "!.git",
                            "--hidden",
                        },

                    },
                },
            })

            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",

        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
