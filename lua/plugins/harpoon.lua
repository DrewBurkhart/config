local function toggle_telescope(harpoon_files)
    local conf = require("telescope.config").values

    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    main = "harpoon", -- so Lazy calls require("harpoon").setup(opts)
    opts = {},
    keys = {
        {
            "<leader>a",
            function()
                require('harpoon'):list():add()
            end,
            desc = "Harpoon add file",
        },
        {
            "<C-e>",
            function()
                require('harpoon.ui'):toggle_quick_menu(require('harpoon'):list())
            end,
            desc = "Harpoon toggle quick menu",
        },
        {
            "<C-r>",
            function()
                toggle_telescope(require('harpoon'):list())
            end,
            desc = "Harpoon toggle quick menu",
        },
        {
            "<C-h>",
            function()
                require('harpoon'):list():select(1)
            end,
            desc = "Harpoon go to file 1",
        },
        {
            "<C-t>",
            function()
                require('harpoon'):list():select(2)
            end,
            desc = "Harpoon go to file 2",
        },
        {
            "<C-n>",
            function()
                require('harpoon.ui'):list():select(3)
            end,
            desc = "Harpoon go to file 3",
        },
        {
            "<C-s>",
            function()
                require('harpoon'):list():select(4)
            end,
            desc = "Harpoon go to file 4",
        },
    },
}
