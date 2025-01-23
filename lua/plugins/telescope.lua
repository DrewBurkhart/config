return {
    'nvim-telescope/telescope.nvim',
    version = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    values = {},
    cmd = "Telescope",
    config = function()
        local telescope = require("telescope")
        telescope.setup({})
    end,
    keys = {
        {
            "<leader>pf",
            function()
                require('telescope.builtin').find_files()
            end,
            desc = "find files"
        },
        {
            "<C-p>",
            function()
                require('telescope.builtin').git_files()
            end,
            desc = "git files"
        },
        {
            "<leaeder>ps",
            function()
                require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") });
            end,
            desc = "Grep for string"
        }
    }
}
