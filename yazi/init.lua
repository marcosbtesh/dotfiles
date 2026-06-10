require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- ~/.config/yazi/init.lua
function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	local readable = "-"
	if size then
		if size < 1024 then
			readable = string.format("%d B", size)
		elseif size < 1048576 then
			readable = string.format("%.0f K", size / 1024)
		elseif size < 1073741824 then
			readable = string.format("%.1f M", size / 1048576)
		else
			readable = string.format("%.1f G", size / 1073741824)
		end
	end

	return string.format("%s %s", readable, time)
end
