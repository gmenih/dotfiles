-- Downscale oversized PNGs before snacks.image transmits them.
--
-- snacks.image sends PNG sources to the terminal as-is (only other formats go
-- through its ImageMagick step, which caps them at 1920x1080). herdr decodes
-- every image to RGBA inside its embedded terminal with a 64 MB storage limit
-- and re-uploads it to Ghostty under a 30 MB per-transaction budget, so a big
-- PNG (a 6500x3500 screenshot is ~91 MB decoded) is dropped silently and the
-- image buffer stays blank. 2560x1600 decodes to ~16 MB, comfortably inside.
local M = {}

M.max_geometry = "2560x1600>"
M.max_pixels = 2560 * 1600

local function png_dimensions(path)
  local out = vim.fn.system({ "magick", "identify", "-ping", "-format", "%w %h", path .. "[0]" })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local width, height = out:match("^(%d+) (%d+)")
  return tonumber(width), tonumber(height)
end

local function scaled_path(src)
  local stat = vim.uv.fs_stat(src)
  local key = vim.fn.sha256(src .. (stat and stat.mtime.sec or 0)):sub(1, 8)
  return Snacks.image.config.cache .. "/" .. key .. "-scaled-" .. vim.fn.fnamemodify(src, ":t")
end

local function downscale(src)
  local width, height = png_dimensions(src)
  if not (width and height) or width * height <= M.max_pixels then
    return nil
  end
  local target = scaled_path(src)
  if not vim.uv.fs_stat(target) then
    vim.fn.mkdir(Snacks.image.config.cache, "p")
    vim.fn.system({ "magick", src .. "[0]", "-scale", M.max_geometry, target })
    if vim.v.shell_error ~= 0 then
      return nil
    end
    Snacks.notify.info(("Downscaled %dx%d image for the terminal"):format(width, height), { title = "snacks.image" })
  end
  return target
end

function M.setup()
  local convert = require("snacks.image.convert")
  if convert._downscale_wrapped then
    return
  end
  convert._downscale_wrapped = true
  local original = convert.convert
  convert.convert = function(opts)
    local src = opts.src
    if type(src) == "string" and not convert.is_uri(src) and src:lower():match("%.png$") then
      local target = downscale(src)
      if target then
        opts = vim.tbl_extend("force", opts, { src = target })
      end
    end
    return original(opts)
  end
end

return M
