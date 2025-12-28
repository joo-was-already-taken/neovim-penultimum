return {
  {
    "evergarden",
    colorscheme = "evergarden",
    after = function(_)
      require("evergarden").setup({
        theme = {
          variant = "winter", -- "winter"|"fall"|"spring"|"summer"
          accent = "green",
        },
        editor = {
          transparent_background = false,
          sign = { color = "none" },
          float = {
            color = "mantle",
            solid_border = false,
          },
          completion = {
            color = "surface0",
          },
        },
      })
    end,
  },
}
