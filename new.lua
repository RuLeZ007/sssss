addEventHandler("onClientPlayerDamage", getLocalPlayer(), 
function (attacker, weapon, bodypart, loss)
    if attacker then
        if attacker ~= source then
            local attackerType = getElementType(attacker)
            if attackerType == "player" then
                cancelEvent()
            elseif attackerType == "ped" then 
                if (getElementData(attacker, "zombie") == true) then
					cancelEvent()
                    triggerServerEvent("ARMORLOS", source, loss, attacker)
                else
                    triggerServerEvent("playereaten", source, source, attacker, weapon, bodypart)
                end
            end 
        end
    end
end)







function KillMessages_onPlayerWasted ( totalammo, killer, killerweapon, bodypart )
	---These are special checks for certain kill types
	local usedVehicle
	if killerweapon == 19 and isElement(killer) then --rockets
		killerweapon = killer and getElementType ( killer ) == "player" and getPedWeapon(killer)
		if not killerweapon then
			killerweapon = 51
		end
	elseif vehicleIDs[killerweapon] then --heliblades/rammed
		if ( isElement(killer) and getElementType ( killer ) == "vehicle" ) then
			usedVehicle = getElementModel ( killer )
			killer = getVehicleOccupant ( killer, 0 )
		end
	elseif ( killerweapon == 59 and isElement(killer) ) then
		if ( getElementType ( killer ) == "player" ) then
			local vehicle = getPedOccupiedVehicle(killer)
			if ( vehicle ) then
				usedVehicle = getElementModel ( vehicle )
			end
		end
	end
	--finish this
	-- Got a killer? Print the normal "* X died" if not
	if ( killer and isElement(killer) and getElementType ( killer ) == "player" ) then
		local kr,kg,kb = getPlayerNametagColor	( killer )
		if getPlayerTeam ( killer ) then
			kr,kg,kb = getTeamColor ( getPlayerTeam ( killer ) )
		end
		-- Suicide?
		if (source == killer) then
			if not killerweapon then killerweapon = 255 end
			local triggered = triggerEvent ( "onPlayerKillMessage", source,false,killerweapon,bodypart )
			outputChatBox("WTF")
			--outputDebugString ( "Cancelled: "..tostring(triggered) )
			if ( triggered ) then
				eventTriggered ( source,false,killerweapon,bodypart,true,usedVehicle)
				outputChatBox("WTF")
				return
			end
		end
		local triggered = triggerEvent ( "onPlayerKillMessage", source,killer,killerweapon,bodypart )
				--outputDebugString ( "Cancelled: "..tostring(triggered) )
		if ( triggered ) then
			eventTriggered ( source,killer,killerweapon,bodypart,false,usedVehicle)
			outputChatBox("WTF")
		end
	else
		local triggered = triggerEvent ( "onPlayerKillMessage", source,false,killerweapon,bodypart )
		--outputDebugString ( "Cancelled: "..tostring(triggered) )
		if ( triggered ) then
			outputChatBox("WTWWWWWF")
			--eventTriggered ( source,false,killerweapon,bodypart,false,usedVehicle)
			if (killer and killer ~= source and getElementType(killer) == "ped") and (getElementData(killer, "zombie") == true) then 
			wr, wg, wb = 162, 2, 2 
			exports.killmessages:outputMessage({"Zombie",{"padding",width=3},{"icon",id=getPedWeapon(killer) or 0},{"padding",width=3},{"color",r=255,g=255,b=255},getPlayerName(source)}, getRootElement(), wr, wg, wb) 
			if not (getElementData(source, "deadEXP") == "True") then
			setElementData(source, "EXP", (getElementData(source, "EXP") or 0) + 1)
			outputChatBox("[!] #FF0000"..getPlayerName(source):gsub("#%x%x%x%x%x%x","").." #00FF00HAS UNLOCKED #FF0000General - [3] #00FF00Achievement [!]", getRootElement(), 0, 255, 0, true)
			setElementData(source, "deadEXP", "True")
			end
			else
			eventTriggered ( source,false,killerweapon,bodypart,false,usedVehicle) 
			outputChatBox("KOKOTINA")
			end
		end
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), KillMessages_onPlayerWasted )
