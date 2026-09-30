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

			-- rlzMenu.Context.SetVisible(false)
			cb({ ok = true })
			return
		end
	end

	cb({ ok = false })
end)
