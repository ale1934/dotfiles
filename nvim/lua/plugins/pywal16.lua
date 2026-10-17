local function set_hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  vim.api.nvim_set_hl(0, group, { link = target })
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

local function rgb_to_hex(rgb)
  return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
end

local function mix(color1, color2, ratio)
  local a = hex_to_rgb(color1)
  local b = hex_to_rgb(color2)
  return rgb_to_hex({
    r = math.floor(a.r + (b.r - a.r) * ratio + 0.5),
    g = math.floor(a.g + (b.g - a.g) * ratio + 0.5),
    b = math.floor(a.b + (b.b - a.b) * ratio + 0.5),
  })
end

local function patch_ui()
  local bg = vim.g.background
  local fg = vim.g.foreground
  local border = vim.g.color8 or fg
  local accent = vim.g.color5 or fg

  if not bg or not fg then
    return
  end

  set_hl("Normal", { fg = fg, bg = bg })
  set_hl("NormalNC", { fg = fg, bg = bg })
  set_hl("SignColumn", { fg = fg, bg = bg })
  set_hl("EndOfBuffer", { fg = bg, bg = bg })
  set_hl("LineNr", { fg = border, bg = bg })
  set_hl("CursorLine", { bg = bg })
  set_hl("StatusLine", { fg = fg, bg = bg })
  set_hl("StatusLineNC", { fg = border, bg = bg })
  set_hl("WinSeparator", { fg = border, bg = bg })
  set_hl("Pmenu", { fg = fg, bg = bg })
  set_hl("PmenuSbar", { bg = bg })
  set_hl("FloatBorder", { fg = border, bg = bg })
  set_hl("TelescopeNormal", { fg = fg, bg = bg })
  set_hl("TelescopeBorder", { fg = accent, bg = bg })
  set_hl("TelescopePromptNormal", { fg = fg, bg = bg })
  set_hl("TelescopePromptBorder", { fg = accent, bg = bg })
  set_hl("TelescopeResultsNormal", { fg = fg, bg = bg })
  set_hl("TelescopeResultsBorder", { fg = accent, bg = bg })
  set_hl("TelescopePreviewNormal", { fg = fg, bg = bg })
  set_hl("TelescopePreviewBorder", { fg = accent, bg = bg })
end

local function patch_snacks()
  local bg = vim.g.background
  local fg = vim.g.foreground
  if not bg or not fg then
    return
  end
  local accent = vim.g.color12 or vim.g.color4 or fg
  local accent_soft = vim.g.color5 or accent
  local muted = mix(fg, bg, 0.45)
  local hidden = mix(fg, bg, 0.18)
  local sel_bg = mix(accent, bg, 0.82)

  set_hl("SnacksPickerFile", { fg = fg, bg = bg })
  set_hl("SnacksPickerDir", { fg = muted, bg = bg })
  set_hl("SnacksPickerDirectory", { fg = accent, bg = bg, bold = true })
  set_hl("SnacksPickerPathHidden", { fg = hidden, bg = bg, italic = true })
  set_hl("SnacksPickerTree", { fg = muted, bg = bg })
  set_hl("SnacksPickerDelim", { fg = muted, bg = bg })
  set_hl("SnacksPickerDimmed", { fg = hidden, bg = bg, italic = true })
  set_hl("SnacksPickerGitStatusIgnored", { fg = hidden, bg = bg, italic = true })
  set_hl("SnacksPickerGitStatusUntracked", { fg = accent_soft, bg = bg })
  set_hl("SnacksPickerGitStatusModified", { fg = accent_soft, bg = bg })
  set_hl("SnacksPickerGitStatusAdded", { fg = vim.g.color10 or accent_soft, bg = bg })
  set_hl("SnacksPickerGitStatusDeleted", { fg = vim.g.color9 or accent_soft, bg = bg })
  set_hl("SnacksPickerMatch", { fg = fg, bg = sel_bg, bold = true })
end

local function patch_neotree()
  local bg = vim.g.background
  local fg = vim.g.foreground
  if not bg or not fg then
    return
  end
  local accent = vim.g.color12 or vim.g.color4 or fg
  local accent_soft = vim.g.color5 or accent
  local muted = mix(fg, bg, 0.45)
  local hidden = mix(fg, bg, 0.22)
  local selected_bg = mix(accent, bg, 0.82)

  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  local line_nr = vim.api.nvim_get_hl(0, { name = "LineNr", link = false })
  local win_separator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })

  set_hl("NeoTreeNormal", { fg = normal.fg, bg = normal.bg })
  set_hl("NeoTreeNormalNC", { fg = normal.fg, bg = normal.bg })
  set_hl("NeoTreeFloatNormal", { fg = float.fg or normal.fg, bg = float.bg or normal.bg })
  set_hl("NeoTreeFloatBorder", { fg = win_separator.fg or line_nr.fg, bg = float.bg or normal.bg })
  set_hl("NeoTreeEndOfBuffer", { fg = normal.bg, bg = normal.bg })
  set_hl("NeoTreeWinSeparator", { fg = win_separator.fg or line_nr.fg, bg = normal.bg })
  set_hl("NeoTreeIndentMarker", { fg = line_nr.fg, bg = normal.bg })
  set_hl("NeoTreeRootName", { fg = accent_soft, bg = normal.bg, bold = true })
  set_hl("NeoTreeDirectoryName", { fg = accent, bg = normal.bg, bold = true })
  set_hl("NeoTreeDirectoryIcon", { fg = accent, bg = normal.bg })
  set_hl("NeoTreeFileName", { fg = fg, bg = normal.bg })
  set_hl("NeoTreeFileIcon", { fg = muted, bg = normal.bg })
  set_hl("NeoTreeFileNameOpened", { fg = accent_soft, bg = normal.bg, italic = true })
  set_hl("NeoTreeDotfile", { fg = hidden, bg = normal.bg })
  set_hl("NeoTreeHiddenByName", { fg = hidden, bg = normal.bg, italic = true })
  set_hl("NeoTreeDimText", { fg = hidden, bg = normal.bg })
  set_hl("NeoTreeSymbolicLinkTarget", { fg = muted, bg = normal.bg, italic = true })
  set_hl("NeoTreeModified", { fg = accent_soft, bg = normal.bg })
  set_hl("NeoTreeFilterTerm", { fg = accent_soft, bg = normal.bg, bold = true })
  set_hl("NeoTreeExpander", { fg = muted, bg = normal.bg })
  set_hl("NeoTreeCursorLine", { bg = selected_bg })
  set_hl("NeoTreeCursorLineNr", { fg = accent_soft, bg = selected_bg, bold = true })
  set_hl("NeoTreeTitleBar", { fg = fg, bg = selected_bg, bold = true })
  set_hl("NeoTreeFileStats", { fg = muted, bg = normal.bg })
  set_hl("NeoTreeMessage", { fg = muted, bg = normal.bg, italic = true })
  link("NeoTreeGitAdded", "Added")
  link("NeoTreeGitModified", "Changed")
  link("NeoTreeGitDeleted", "Removed")
end

return {
  {
    "uZer/pywal16.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("pywal16")

      local group = vim.api.nvim_create_augroup("eno_pywal16", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "pywal16",
        callback = function()
          patch_ui()
          patch_snacks()
          patch_neotree()
        end,
      })

      patch_ui()
      patch_snacks()
      patch_neotree()

      vim.api.nvim_create_user_command("WalReload", function()
        vim.cmd.colorscheme("pywal16")
      end, { desc = "Reload pywal16 colorscheme" })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "pywal16",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "pywal16-nvim"
    end,
  },
}
