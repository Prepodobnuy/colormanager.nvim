# colormanager.nvim

Plugin to store last used color & background color

## Usage

```lua
require('colormanager').select() -- select colorscheme
require('colormanager').toggle() -- toggle background color
```

## Configure

```lua
require('colormanager').setup({})
```

## Example configuration

```lua
-- with Lazy.nvim
return {
  'prepodobnuy/colormanager.nvim',
  priority = 1000,
  opts = {
    colors = {
      { name = 'Cyberdream', set = 'cyberdream' },
      { name = 'Everforest', set = 'everforest' },
      { name = 'Evergarden', set = 'evergarden' },
      -- Applies color scheme based on vim.o.background: uses 'dark'/'light'
      -- values if specified, otherwise falls back to 'set'. Essential for
      -- color schemes without automatic background switching support.
      { name = 'Github', dark = 'github_dark', light = 'github_light' },
      { name = 'Gruber Darker', set = 'gruber-darker' },
      { name = 'Gruvbox', set = 'gruvbox' },
      { name = 'Kanagawa', set = 'kanagawa' },
      { name = 'Mellow', set = 'mellow' },
      { name = 'Tokyonight', set = 'tokyonight' },
      { name = 'Vscode', set = 'vscode' },
    },
    fallback = 'Gruvbox',
  },
  dependencies = {
    'scottmckendry/cyberdream.nvim',
    'neanias/everforest-nvim',
    'everviolet/nvim',
    'projekt0n/github-nvim-theme',
    'blazkowolf/gruber-darker.nvim',
    'ellisonleao/gruvbox.nvim',
    'rebelot/kanagawa.nvim',
    'mellow-theme/mellow.nvim',
    'folke/tokyonight.nvim',
    'Mofiqul/vscode.nvim',
  },
}
```

## License MIT
