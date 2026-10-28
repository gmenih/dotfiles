-- Mirrors ~/.config/herdr/config.toml: ctrl+a prefix, tmux-flavoured bindings.
-- herdr "workspace" = rex session, herdr "tab" = rex tab.

local prefix = "ctrl+a"

local function bind(key, action, args)
  rex.bind(prefix .. ">" .. key, action, args)
end

bind(prefix, "pane.send_key", { key = prefix })

-- Panes
bind("shift+\\", "pane.split.right")
bind("\\", "pane.split.down")
bind("h", "pane.focus.left")
bind("j", "pane.focus.down")
bind("k", "pane.focus.up")
bind("l", "pane.focus.right")
bind("m", "pane.zoom")
bind("z", "pane.zoom")
bind("x", "pane.close")
bind("shift+tab", "pane.focus_previous")

rex.mode("resize", { exclusive = true })
bind("shift+r", "client.mode.enter", { name = "resize" })
for key, direction in pairs({
  h = "left", j = "down", k = "up", l = "right",
  left = "left", down = "down", up = "up", right = "right",
}) do
  rex.bind("resize/" .. key, "pane.resize", { direction = direction })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = direction, amount = 15 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/q", "client.mode.exit")

-- Tabs
bind("c", "client.tab.new")
bind("n", "client.tab.next")
bind("p", "client.tab.previous")
bind(",", "client.tab.rename")
bind("shift+t", "client.tab.rename")
bind("shift+x", "client.tab.close")
for i = 1, 9 do
  bind(tostring(i), "client.tab.goto", { index = i })
end

-- Sessions (herdr workspaces)
bind("s", "session.switch")
bind("g", "session.switch")
bind("w", "session.switch")
bind("shift+n", "session.new")
bind("shift+w", "session.rename")
bind("shift+d", "session.close")

-- App
bind("r", "client.config.reload")
bind("tab", "client.sidebar.toggle")
bind("shift+,", "client.settings")
bind("shift+/", "client.palette.toggle")

-- Commands
local terminal = "com.superlogical.terminal"

local function focused_cwd()
  local result = rex.block.call(terminal, "pwd", {})
  return result and result.pwd or nil
end

rex.action{
  name = "scratch_terminal",
  title = "Scratch Terminal",
  run = function()
    rex.session.new_layer{
      bounds = { 0.1, 0.1, 0.8, 0.8 },
      focus = true,
      layout = { block = { flavor = terminal .. ".shell", options = { cwd = focused_cwd() } } },
    }
  end,
}
bind("shift+p", "scratch_terminal")

rex.action{
  name = "neogit",
  title = "Neogit in Current Dir",
  run = function()
    rex.session.new_split{
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = {
        block = {
          flavor = terminal .. ".shell",
          label = "nvim",
          options = { cwd = focused_cwd(), command = "nvim +Neogit" },
        },
      },
    }
  end,
}
bind("o", "neogit")

-- Bare ctrl+hjkl: move between panes, but let nvim keep the key when it is the
-- foreground program so its own window navigation works.
local function runs_vim()
  local process = rex.block.call(terminal, "process", {})
  local name = process and process.foreground and process.foreground.name or ""
  return name == "nvim" or name == "vim"
end

for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("ctrl+" .. key, function()
    if runs_vim() then
      return false
    end
    rex.client.queue("pane.focus." .. direction)
    return true
  end)
end
