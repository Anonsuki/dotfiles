return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    default_mappings = true, -- Set to false if you want to define your own mappings
    builtin_marks = { ".", "<", ">", "^" }, -- Which builtin marks to show in the sign column
    cyclic = true,           -- Whether movements cycle back to the beginning/end of buffer
    -- Add more options here based on the documentation
  },
}
