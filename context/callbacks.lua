local function findContextItem(items, itemId)
	for _, item in ipairs(items) do
		if item.id == itemId then
			return item
		end

		if item.items then
			local nestedItem = findContextItem(item.items, itemId)
			if nestedItem then
				return nestedItem
			end
		end
	end

	return nil
end

RegisterNUICallback("rlz_menu:context:selectButton", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	local item = findContextItem(CONTEXT_CURRENT.items, itemId)

	if item and item.type == "button" then
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

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:selectCheckbox", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	local item = findContextItem(CONTEXT_CURRENT.items, itemId)

	if item and (item.type == "checkbox" or item.type == "switch") then
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

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:hoverItem", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	local item = findContextItem(CONTEXT_CURRENT.items, itemId)

	if item then
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

	cb({ ok = false })
end)

RegisterNUICallback("rlz_menu:context:leaveItem", function(data, cb)
	local itemId = data.itemId

	if type(itemId) ~= "string" or not CONTEXT_CURRENT then
		cb({ ok = false })
		return
	end

	local item = findContextItem(CONTEXT_CURRENT.items, itemId)

	if item then
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

	cb({ ok = false })
end)
