With (lazy.nvim)[https://github.com/folke/lazy.nvim]
```lazy
  {
    'blumaa/octopus.nvim',
    config = function()
      vim.keymap.set('n', '<leader>on', function() require("octopus").spawn() end, {})
      vim.keymap.set('n', '<leader>off', function() require("octopus").remove_last_octopus() end, {})
      vim.keymap.set('n', '<leader>ofa', function() require("octopus").remove_all_octopuses() end, {})
    end
  },

```

