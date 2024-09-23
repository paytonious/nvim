return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = function ()
    opts = {}
    require("ibl").setup()
  end
}
