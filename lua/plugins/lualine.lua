return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- remove right side junk
      opts.sections.lualine_x = {}

      -- remove clock / position stuff
      opts.sections.lualine_y = {}

      -- remove line:column like 9:8
      opts.sections.lualine_z = {}

      return opts
    end,
  },
}
