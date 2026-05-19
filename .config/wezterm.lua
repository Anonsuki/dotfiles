local wezterm = require "wezterm"
local act = wezterm.action
-- local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require "https://github.com/MLFlexer/smart_workspace_switcher.wezterm"
local smart_splits = wezterm.plugin.require "https://github.com/mrjones2014/smart-splits.nvim"

local function is_editor(pane)
  local process_name = pane:get_foreground_process_name()
  if not process_name then
    return false
  end
  -- Pattern match against common CLI text editors to prevent accidental data loss
  return process_name:match "nvim" or process_name:match "vim" or process_name:match "nano" or process_name:match "hx"
end

wezterm.on("window-config-reloaded", function(window, pane)
  resurrect.save_state(resurrect.workspace_state.get_workspace_state())
  wezterm.log_info "Workspace state automatically saved due to configuration reload."
end)

-- --- UI State Toggling Logic ---
-- Dynamically intercepts and mutates the window configuration state
-- to summon or banish the tab bar without requiring a daemon restart.
wezterm.on("toggle-tabbar", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.enable_tab_bar = not overrides.enable_tab_bar
  window:set_config_overrides(overrides)
end)

-- --- Native Mode-Aware HUD (Left/Right Status) ---
wezterm.on("update-status", function(window, pane)
  -- 1. Determine Current Mode
  local mode = " NORMAL "
  local mode_bg = "#000000" -- Black
  local mode_fg = "#d4be98" -- Cream/Tan

  if window:leader_is_active() then
    mode = " LEADER "
    mode_bg = "#EBD28B" -- Yellow
    mode_fg = "#000000" -- Black
  else
    local active_key_table = window:active_key_table()
    if active_key_table == "copy_mode" then
      mode = " COPY "
      mode_bg = "#ff5555" -- Red
      mode_fg = "#000000"
    elseif active_key_table == "search_mode" then
      mode = " SEARCH "
      mode_bg = "#50fa7b" -- Green
      mode_fg = "#000000"
    end
  end

  -- 2. Fetch Workspace
  local workspace = window:active_workspace()

  -- 3. Draw Left Status (Mode + Workspace)
  window:set_left_status(wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = mode_bg } },
    { Foreground = { Color = mode_fg } },
    { Text = mode },
    { Background = { Color = "#191919" } }, -- Black Workspace BG
    { Foreground = { Color = "#d4be98" } }, -- Cream Workspace Text
    { Text = " " .. workspace .. " " },
    { Background = { Color = "transparent" } },
    { Text = " " }, -- Spacer
  })
end)

-- --- Native Clean Tab Formatting ---
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  -- Strip paths, keep it clean
  title = title:match "([^/\\]+)$" or title
  title = title:gsub("%.exe$", "")
  if title == "wslhost" or title == "wsl" then
    title = "zsh"
  end

  -- Determine colors based on active state
  local bg = tab.is_active and "#191919" or "transparent"
  local fg = tab.is_active and "#d4be98" or "#5B5E5F"
  local intensity = tab.is_active and "Bold" or "Normal"

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Attribute = { Intensity = intensity } },
    { Text = string.format(" %d: %s ", tab.tab_index + 1, title) },
  }
end)

-- --- Main Config ---
local config = wezterm.config_builder()

-- Zoxide Integration
workspace_switcher.zoxide_path = "zoxide"

-- UI & Performance
config.color_scheme = "Gruvbox Material (Gogh)"
config.window_background_opacity = 0.7
config.win32_system_backdrop = "Acrylic"
config.window_decorations = "NONE | RESIZE"

config.front_end = "WebGpu"
-- config.webgpu_power_preference = "HighPerformance"
config.freetype_load_target = "Light"
config.freetype_render_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"
config.display_pixel_geometry = "RGB"
config.max_fps = 120
config.term = "xterm-256color"

config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

config.prefer_egl = true
config.cell_width = 0.9
config.line_height = 1.0
config.initial_cols = 80
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 60
config.cursor_blink_rate = 500

config.colors = {
  background = "#000000",
  tab_bar = {
    -- Forces the entire bar container to match your acrylic transparency
    background = "transparent",

    active_tab = {
      bg_color = "transparent",
      fg_color = "#A89984", -- Gruvbox Material Active Text
      intensity = "Bold",
      italic = false,
    },
    inactive_tab = {
      bg_color = "transparent",
      fg_color = "#504945", -- Gruvbox Material Muted Text
    },
    new_tab = {
      bg_color = "transparent",
      fg_color = "#504945",
    },
  },
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

-- Fonts
config.window_frame = { font = wezterm.font { family = "Iosevka Custom", weight = "Regular" } }
config.font = wezterm.font_with_fallback {
  {
    family = "Iosevka Custom",
    stretch = "Normal",
    weight = "Medium",
    style = "Normal",
    harfbuzz_features = { "calt=1", "clig=1", "liga=1", "cv02", "ss01", "cv24", "cv31" },
  },
  { family = "Symbols Nerd Font Mono" },
}

config.font_size = 10.0

-- Backend & Updates
config.check_for_updates = false
config.warn_about_missing_glyphs = false
config.scrollback_lines = 10000
config.default_domain = "WSL:Arch"

-- config.unix_domains = { { name = 'unix' } }
-- config.default_gui_startup_args = { 'connect', 'unix' }

-- --- Future Remote Infrastructure (SSH) ---
-- A scalable block mapping remote servers as persistent domains, negating the need for nested Tmux over SSH.
-- config.ssh_domains = {
-- {
-- Un-comment and modify when implementing remote node infrastructure
-- name = "primary_cloud_node",
-- remote_address = "203.0.113.10",
-- username = "admin",
-- },
-- }

-- --- Multiplexer Keybinding Matrix ---
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- =========================================================
  -- 1. Core Multiplexer State (Daemon/Session Parity)
  -- =========================================================
  { key = "d", mods = "LEADER", action = act.DetachDomain "CurrentPaneDomain" },
  {
    key = "$",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine {
      description = "Enter new name for workspace",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(window:mux_window():get_workspace(), line)
        end
      end),
    },
  },
  -- Tmux-style rapid lateral workspace (session) cycling
  { key = "(", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
  { key = ")", mods = "LEADER|SHIFT", action = act.SwitchWorkspaceRelative(1) },

  -- =========================================================
  -- 2. Tab (Window) Lifecycle & Navigation
  -- =========================================================
  { key = "c", mods = "LEADER", action = act.SpawnTab "CurrentPaneDomain" },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "a", mods = "LEADER", action = act.ActivateLastTab },
  -- Since your leader is Ctrl-a, hitting Ctrl-a then a toggles tabs.

  { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- =========================================================
  -- 3. Pane Splitting & Spatial Management
  -- =========================================================
  { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "\\", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "{", mods = "LEADER|SHIFT", action = act.PaneSelect { mode = "SwapWithActive" } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  {
    key = "x",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      if is_editor(pane) then
        -- If an editor is running, enforce safety protocol
        wezterm.log_info "Editor detected: Enforcing confirmation constraint."
        window:perform_action(act.CloseCurrentPane { confirm = true }, pane)
      else
        -- If it's a standard shell, terminate immediately to preserve momentum
        window:perform_action(act.CloseCurrentPane { confirm = false }, pane)
      end
    end),
  },
  {
    key = "E",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      -- 1. Spawn a clean, foundational tab
      local tab, main_pane, mux_window = window:mux_window():spawn_tab {}

      -- 2. Execute mathematical spatial division
      -- Split the main pane to the right, taking up 40% of the total width
      local right_top_pane = main_pane:split { direction = "Right", size = 0.4 }

      -- Split that new right pane horizontally to create a bottom right quadrant
      local right_bottom_pane = right_top_pane:split { direction = "Bottom", size = 0.5 }

      -- 3. Programmatic Command Injection
      -- Automatically launch Neovim in the primary focal pane
      main_pane:send_text "nvim \n"
      -- Automatically clear the secondary panes for a pristine visual state
      right_top_pane:send_text "clear\n"
      right_bottom_pane:send_text "clear\n"

      wezterm.log_info "Development layout successfully bootstrapped."
    end),
  },

  -- =========================================================
  -- 4. Buffer Interaction & Modals
  -- =========================================================
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },

  -- =========================================================
  -- 5. The Zoxide-Powered Workspace Injection
  -- =========================================================
  { key = "f", mods = "LEADER", action = workspace_switcher.switch_workspace() },

  -- =========================================================
  -- 6. Arbitrary Workspace Instantiation
  -- =========================================================
  {
    key = "s",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = "#d4be98" } }, -- Gruvbox Cream
        { Text = "Enter name for new workspace:" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- WezTerm's SwitchToWorkspace action automatically creates the workspace
        -- if the designated name does not already exist in the daemon's state.
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },

  -- =========================================================
  -- 7. Persistent State Management (Resurrect Plugin)
  -- =========================================================
  {
    key = "S",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      resurrect.save_state(resurrect.workspace_state.get_workspace_state())
      wezterm.log_info "Workspace state saved manually."
    end),
  },
  {
    key = "R",
    mods = "LEADER|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      resurrect.fuzzy_load(window, pane, function(id, label) end)
    end),
  },

  -- =========================================================
  -- 8. Dynamic UI Toggling
  -- =========================================================
  { key = "t", mods = "LEADER", action = act.EmitEvent "toggle-tabbar" },
}

-- =========================================================
-- 9. Programmatic Tab Injection (Leader + 1-9)
-- =========================================================
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

smart_splits.apply_to_config(config, {
  direction_keys = {
    move = { "h", "j", "k", "l" },
    resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
  },
  modifiers = {
    move = "CTRL",
    resize = "META",
  },
})

-- I also use the smart-splits.nvim plugin with WezTerm.

return config
