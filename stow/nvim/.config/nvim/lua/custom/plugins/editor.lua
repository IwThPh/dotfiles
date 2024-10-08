return {
    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", opts = {} },
    { -- buffer remove
        "echasnovski/mini.bufremove",

        keys = {
            -- stylua: ignore start
            { "<leader>bd", function() require("mini.bufremove").delete(0) end,       desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
            -- stylua: ignore end
        },
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            -- stylua: ignore start
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Attach" })
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "Harpoon Target List" })
            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon Target 1" })
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon Target 2" })
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon Target 3" })
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon Target 4" })
            vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon Target 5" })
            -- stylua: ignore end

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function()
                harpoon:list():prev()
            end, { desc = "Harpoon Next Target" })
            vim.keymap.set("n", "<C-S-N>", function()
                harpoon:list():next()
            end, { desc = "Harpoon Previous Target" })
        end,
    },

    {
        "folke/zen-mode.nvim",
        keys = {
            -- stylua: ignore
            { "<leader>uz", function() require("zen-mode").toggle() end, desc = "Toggle Zenmode" },
        },
        opts = {
            window = {
                options = {
                    signcolumn = "no",      -- disable signcolumn
                    number = false,         -- disable number column
                    relativenumber = false, -- disable relative numbers
                    cursorline = false,     -- disable cursorline
                    cursorcolumn = false,   -- disable cursor column
                    foldcolumn = "0",       -- disable fold column
                    list = false,           -- disable whitespace characters
                },
            },
            plugins = {
                options = {
                    laststatus = 0,             -- turn off the statusline in zen mode
                },
                gitsigns = { enabled = false }, -- disables git signs
                kitty = {
                    -- this will change the font size on kitty when in zen mode
                    -- to make this work, you need to set the following kitty options:
                    -- - allow_remote_control socket-only
                    -- - listen_on unix:/tmp/kitty
                    enabled = true,
                    font = "+4", -- font size increment
                },
                alacritty = {
                    enabled = true,
                    font = "18", -- font size
                },
            },
            -- callback where you can add custom code when the Zen window opens
            on_open = function(win)
                vim.cmd("IBLDisable")
                vim.opt.linebreak = true
            end,
            -- callback where you can add custom code when the Zen window closes
            on_close = function()
                vim.cmd("IBLEnable")
                vim.opt.linebreak = false
            end,
        },
    },
}
