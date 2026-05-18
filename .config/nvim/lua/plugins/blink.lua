return {
  "saghen/blink.cmp",
  lazy = true,
  dependencies = {
    "saghen/blink.compat",
    "fang2hou/blink-copilot",
  },
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "avante_commands", "avante_mentions", "avante_files" },
      compat = {
        "avante_commands",
        "avante_mentions",
        "avante_files",
      },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 3,
            kind_name = "Copilot",
            kind_icon = " ",
          },
        },
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 90,
          opts = {},
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 100,
          opts = {},
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 1000,
          opts = {},
        },
      },
    },
  },
}
