-- Require sketchybar module
sbar = require("sketchybar")

-- Bundle initial config into a single message to sketchybar
sbar.begin_config()

require("bar")
require("default")
require("items")

sbar.hotload(true)
sbar.add("event", "aerospace_workspace_change")

sbar.end_config()

sbar.event_loop()

sbar.trigger("space_windows_change")
sbar.trigger("aerospace_workspace_change")
