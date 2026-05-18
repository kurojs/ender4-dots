return {
  {
    -- {
    --   "xiyaowong/transparent.nvim",
    --   config = function()
    --     require("transparent").setup({
    --       extra_groups = { -- table/string: additional groups that should be cleared
    --         "Normal",
    --         "NormalNC",
    --         "Comment",
    --         "Constant",
    --         "Special",
    --         "Identifier",
    --         "Statement",
    --         "PreProc",
    --         "Type",
    --         "Underlined",
    --         "Todo",
    --         "String",
    --         "Function",
    --         "Conditional",
    --         "Repeat",
    --         "Operator",
    --         "Structure",
    --         "LineNr",
    --         "NonText",
    --         "SignColumn",
    --         "CursorLineNr",
    --         "EndOfBuffer",
    --       },
    --       exclude_groups = {}, -- table: groups you don't want to clear
    --     })
    --   end,
    -- },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      },
    },
    {
      "Gentleman-Programming/gentleman-kanagawa-blur",
      name = "gentleman-kanagawa-blur",
      priority = 1000,
      config = function()
        local variant = require("gentleman_kanagawa_blur.variant")
        local blur = variant("blur")

        -- Azul → Morado kurox
        blur.blue = "#A78BFA"
        blur.primary = "#A78BFA"
        blur.bright_blue = "#C4B5FD"
        blur.link_uri = "#A78BFA"
        blur.link_text = "#A78BFA"

        -- El "purple" del palette es en realidad azul apagado → morado real
        blur.purple = "#A78BFA"
        blur.bright_purple = "#C4B5FD"

        -- Verde → Verde kurox
        blur.green = "#4ADE80"
        blur.bright_green = "#86EFAC"
        blur.number = "#86EFAC"
        blur.diff_add_bg = "#0F291E"
        blur.type = "#86EFAC"

        -- Accent a verde kurox
        blur.accent = "#4ADE80"

        -- Constant a verde
        blur.constant = "#4ADE80"

        -- Constructor a morado
        blur.constructor = "#A78BFA"

        -- Tag a morado
        blur.tag = "#A78BFA"

        -- Snacks integration usa subtext1/subtext4 que no existen en blur
        blur.subtext1 = "#5C6170"
        blur.subtext4 = "#5C6170"

        require("gentleman_kanagawa_blur").setup({
          highlight_overrides = {
            -- Morado
            ["Function"] = { fg = "#A78BFA" },
            ["Keyword"] = { fg = "#A78BFA", italic = true },
            ["Statement"] = { fg = "#A78BFA", bold = true },
            ["Special"] = { fg = "#C4B5FD" },
            ["Include"] = { fg = "#C4B5FD" },
            ["Define"] = { fg = "#A78BFA" },
            ["PreProc"] = { fg = "#A78BFA" },
            ["DiagnosticHint"] = { fg = "#A78BFA" },
            ["@function"] = { fg = "#A78BFA" },
            ["@keyword"] = { fg = "#A78BFA", italic = true },
            ["@function.builtin"] = { fg = "#C4B5FD" },
            ["@function.call"] = { fg = "#A78BFA" },
            ["@function.method.call"] = { fg = "#A78BFA" },
            ["@tag"] = { fg = "#A78BFA" },
            -- Dashboard header: verde kurox (antes era purple/azul)
            ["SnacksDashboardHeader"] = { fg = "#4ADE80" },
            ["SnacksDashboardFooter"] = { fg = "#A78BFA", italic = true },
            ["SnacksDashboardSpecial"] = { fg = "#C4B5FD", bold = true, italic = true },
            ["SnacksDashboardIcon"] = { fg = "#86EFAC" },
            -- Verde kurox
            ["Type"] = { fg = "#86EFAC" },
            ["Identifier"] = { fg = "#4ADE80" },
            ["Number"] = { fg = "#86EFAC" },
            ["Constant"] = { fg = "#4ADE80" },
            ["DiagnosticInfo"] = { fg = "#86EFAC" },
            ["@type"] = { fg = "#86EFAC" },
            ["@variable"] = { fg = "#F3F6F9" },
            ["@string"] = { fg = "#FDE68A" },
            ["@number"] = { fg = "#86EFAC" },
            ["@operator"] = { fg = "#FCD34D" },
            ["@punctuation"] = { fg = "#94A3B8" },
            ["@comment"] = { fg = "#64748B" },
            ["@variable.member"] = { fg = "#4ADE80" },
            ["@variable.parameter"] = { fg = "#FDE68A" },
            ["@property"] = { fg = "#4ADE80" },
            ["@tag.attribute"] = { fg = "#86EFAC" },
            ["@tag.delimiter"] = { fg = "#94A3B8" },
          },
        })
        vim.cmd.colorscheme("gentleman-kanagawa-blur")
      end,
    },
    {
      "Alan-TheGentleman/oldworld.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
      "rebelot/kanagawa.nvim",
      priority = 1000,
      lazy = true,
      config = function()
        require("kanagawa").setup({
          compile = false, -- enable compiling the colorscheme
          undercurl = true, -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = {},
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = {},
          transparent = true, -- do not set background color
          dimInactive = false, -- dim inactive window `:h hl-NormalNC`
          terminalColors = true, -- define vim.g.terminal_color_{0,17}
          colors = { -- add/modify theme and palette colors
            palette = {},
            theme = {
              wave = {},
              lotus = {},
              dragon = {},
              all = {
                ui = {
                  bg_gutter = "none", -- set bg color for normal background
                  bg_sidebar = "none", -- set bg color for sidebar like nvim-tree
                  bg_float = "none", -- set bg color for floating windows
                },
              },
            },
          },
          overrides = function(colors) -- add/modify highlights
            return {
              LineNr = { bg = "none" },
              NormalFloat = { bg = "none" },
              FloatBorder = { bg = "none" },
              FloatTitle = { bg = "none" },
              TelescopeNormal = { bg = "none" },
              TelescopeBorder = { bg = "none" },
              LspInfoBorder = { bg = "none" },
            }
          end,
          theme = "wave", -- Load "wave" theme
          background = { -- map the value of 'background' option to a theme
            dark = "wave", -- try "dragon" !
            light = "lotus",
          },
        })
      end,
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "gentleman-kanagawa-blur",
      },
    },
  },
}
