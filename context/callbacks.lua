RegisterNUICallback("rlz_menu:context:selectButton", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	for _, item in ipairs(CONTEXT_CURRENT.items) do
		if item.id == itemId and item.type == "button" then
			if item.disabled then
				cb({ ok = false, disabled = true })
				return
			end

			if item.onClick then
				item.onClick()
			end

			cb({ ok = true })
			return
		end
	end

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:selectCheckbox", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	for _, item in ipairs(CONTEXT_CURRENT.items) do
		if item.id == itemId and item.type == "checkbox" then
			if item.disabled then
				cb({ ok = false, disabled = true })
				return
			end

			item.isChecked = not item.isChecked

			if item.onToggle then
				item.onToggle(item.isChecked)
			end

			playSound("select")
			cb({ ok = true, checked = item.isChecked })
			return
		end
	end

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:hoverItem", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	for _, item in ipairs(CONTEXT_CURRENT.items) do
		if item.id == itemId then
			if item.disabled then
				cb({ ok = false, disabled = true })
				return
			end

			if item.onHover then
				item.onHover()
			end

			cb({ ok = true })
			return
		end
	end

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:leaveItem", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	for _, item in ipairs(CONTEXT_CURRENT.items) do
		if item.id == itemId then
			if item.disabled then
				cb({ ok = false, disabled = true })
				return
			end

			if item.onLeave then
				item.onLeave()
			end

			cb({ ok = true })
			return
		end
	end

	cb({ ok = false })
end)
