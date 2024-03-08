--- STEAMODDED HEADER
--- MOD_NAME: More Jokers!
--- MOD_ID: moreJoker
--- MOD_AUTHOR: [Selectromoo]
--- MOD_DESCRIPTION: Adds more Jokers to the game!
----------------------------------------------
------------MOD CODE -------------------------

local MOD_ID = "moreJoker"

--Code to add jokers to game; from https://github.com/GoldenEpsilon/ShamPack
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
    set_spritesref(self, _center, _front);
    if _center then
        if _center.set then
            if (_center.set == 'Joker' or _center.consumeable or _center.set == 'Voucher') and _center.atlas then
                self.children.center.atlas = G.ASSET_ATLAS
                    [(_center.atlas or (_center.set == 'Joker' or _center.consumeable or _center.set == 'Voucher') and _center.set) or 'centers']
                self.children.center:set_sprite_pos(_center.pos)
            end
        end
    end
end

--https://github.com/GoldenEpsilon/ShamPack
function add_item(mod_id, pool, id, data, desc)
    -- Add Sprite
    data.pos = { x = 0, y = 0 };
    data.key = id;
    data.atlas = mod_id .. id;
    SMODS.Sprite:new(mod_id .. id, SMODS.findModByID(mod_id).path, id .. ".png", 71, 95, "asset_atli"):register();

    data.key = id
    data.order = #G.P_CENTER_POOLS[pool] + 1
    G.P_CENTERS[id] = data
    table.insert(G.P_CENTER_POOLS[pool], data)

    if pool == "Joker" then
        table.insert(G.P_JOKER_RARITY_POOLS[data.rarity], data)
    end

    G.localization.descriptions[pool][id] = desc;
end

--https://github.com/GoldenEpsilon/ShamPack
function refresh_items()
    for k, v in pairs(G.P_CENTER_POOLS) do
        table.sort(v, function(a, b) return a.order < b.order end)
    end

    -- Update localization
    for g_k, group in pairs(G.localization) do
        if g_k == 'descriptions' then
            for _, set in pairs(group) do
                for _, center in pairs(set) do
                    center.text_parsed = {}
                    for _, line in ipairs(center.text) do
                        center.text_parsed[#center.text_parsed + 1] = loc_parse_string(line)
                    end
                    center.name_parsed = {}
                    for _, line in ipairs(type(center.name) == 'table' and center.name or { center.name }) do
                        center.name_parsed[#center.name_parsed + 1] = loc_parse_string(line)
                    end
                    if center.unlock then
                        center.unlock_parsed = {}
                        for _, line in ipairs(center.unlock) do
                            center.unlock_parsed[#center.unlock_parsed + 1] = loc_parse_string(line)
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(G.P_JOKER_RARITY_POOLS) do
        table.sort(G.P_JOKER_RARITY_POOLS[k], function(a, b) return a.order < b.order end)
    end
end

--Joker metadata
function SMODS.INIT.moreJoker()

	add_item(MOD_ID, "Joker", "j_buffet", 
	{order = 1, unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 4, name = "Buffet", set = "Joker", config = {extra = {chips = 15, chip_mod = 15}}},
	{
		name = "Buffet",
		text = {"When {C:attention}Blind{} is selected,", "Gains {C:chips}+#2#{} Chips", "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"} --When blind is selected, Gains +20 Chips (Currently +X Chips)
	})

	add_item(MOD_ID, "Joker", "j_salesman",
	{order = 2, unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 3, name = "Salesman Joker", set = "Joker", config = {extra = 4}},
	{
		name = "Salesman Joker",
		text = {"Sells for {C:money}X#1#{} value"} --Sells for x4 value
	})

	add_item(MOD_ID, "Joker", "j_conglomerate",
	{order = 3, unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true, rarity = 3, cost = 8, name = "Conglomerate Joker", set = "Joker", config = {extra = 1}},
	{
		name = "Conglomerate Joker",
		text = {"Each played card with", "{V:1}#2#{} suit gives", "{C:money}+$#1#{} when scored,", "{s:0.8}suit changes at end of round"} --+$1 for each card played of a specific suit. The suit changes at the end of each round.
	})

	add_item(MOD_ID, "Joker", "j_dressing_table",
	{order = 4, unlocked = true, discovered = true, blueprint_compat = false, eternal_compat = true, rarity = 2, cost = 5, name = "Dressing Table", set = "Joker", config = {extra = 5}},
	{
		name = "Dressing Table",
		text = {"{C:green}#1# in #2#{} chance to", "give a random Joker", "{C:dark_edition}Foil, Holographic,{} or {C:dark_edition}Polychrome{}", "at the end of each round"} --1 in 5 chance to give a Joker Foil, Holographic, Polychrome or Negative at the end of each round.
	})

	add_item(MOD_ID, "Joker", "j_pay_to_win",
	{order = 5, unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true, rarity = 2, cost = 6, name = "Pay to Win", set = "Joker", config = {extra = 3}},
	{
		name = "Pay to Win",
		text = {"Playing a hand costs {C:money}$#2#{}", "and provides {X:mult,C:white}X1.5{} Mult"} --Playing a hand costs $3 and provides x1.5 Mult.
	})

	add_item(MOD_ID, "Joker", "j_archibald",
	{order = 6, unlocked = true, discovered = true, blueprint_compat = true, eternal_compat = true, rarity = 4, cost = 20, name = "Archibald", set = "Joker", config = {extra = 0.25}, pos = {x=5,y=8}, soul_pos = {x=5, y=9}, unlock_condition = {type = '', extra = '', hidden = true}},
	{
		name = "Archibald",
		text = {"Gains {X:mult,C:white}X#2#{} Mult with", "every {C:attention}Shop{} purchase", "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"}, --Starting at x1 Mult, gains x0.25 Mult with every shop purchase.
		unlock = {"{E:1,s:1.3}?????"}
	})

	--[[
	local moreJokers = {
		--j_gaggle = {order = 2, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 4, name = "Gaggle", set = "Joker", config = {extra = {chips = 200, Xmult = 0.5}}, pos = {x=1,y=12}},
		--j_connoisseur = {order = 3, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 2, cost = 5, name = "Connoisseur", set = "Joker", config = {extra = {chips = -200, Xmult = 1.5}}, pos = {x=6,y=5}},
	}

	local jokerDesc = {
		j_gaggle = {
			name = "Gaggle",
			text = {"{C:chips}+#1#{} Chips", "{X:mult,C:white}X#2#{} Mult"} --+300 Chips, X0.5 Mult
		},
		j_connoisseur = {
			name = "Connoisseur",
			text = {"{C:chips}#1#{} Chips", "{X:mult,C:white}X#2#{} Mult"} -- -300 Chips, X1.5 Mult
		},
	}
	]]--

	refresh_items()
end

--Joker ability implementation
local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
	return set_abilityref(self, center, initial, delay_sprites)
end

local calculate_jokerref = Card.calculate_joker
function Card.calculate_joker(self, context)
	local calc_ref = calculate_jokerref(self, context)

	if self.ability.set == "Joker" and not self.debuff then

		--Bluprint/Brainstorm checks
		if self.ability.name == "Blueprint" then
			local other_joker = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == self then
					other_joker = G.jokers.cards[i+1]
				end
			end
			if other_joker and other_joker ~= self then
				context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
				context.blueprint_card = context.blueprint_card or self
				if context.blueprint > #G.jokers.cards + 1 then
					return
				end
				local other_joker_ret = other_joker:calculate_joker(context)
				if other_joker_ret then 
					other_joker_ret.card = context.blueprint_card or self
					other_joker_ret.colour = G.C.BLUE
					return other_joker_ret
				end
			end
		end
		if self.ability.name == "Brainstorm" then
			local other_joker = G.jokers.cards[1]
			if other_joker and other_joker ~= self then
				context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
				context.blueprint_card = context_blueprint_card or self
				if context_blueprint > #G.jokers. cards + 1 then
					return
				end
				local other_joker_ret = other_joker:calculate_joker(context)
				if other_joker_ret then
					other_joker_ret.card = context.blueprint_card or self
					other_joker_ret.colour = G.C.RED
					return other_joker_ret
				end
			end
		end

		--All types of manipulation, joker effects go under respective category
		if context.open_booster then
			if self.ability.name == "Archibald" and not context.blueprint then
				self.ability.x_mult = self.ability.x_mult + self.ability.extra
				return {
					card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
				}
			end
        elseif context.buying_card then
			if self.ability.name == "Archibald" and not context.blueprint then
				self.ability.x_mult = self.ability.x_mult + self.ability.extra
				return {
					card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}}})
				}
			end
        elseif context.selling_self then
			if self.ability.name == "Salesman Joker" then
				self.ability.extra_value = (self.sell_cost * self.ability.extra) - self.sell_cost
				self:set_cost()
			end
        elseif context.selling_card then
        elseif context.reroll_shop then
        elseif context.ending_shop then
        elseif context.skip_blind then
        elseif context.skipping_booster then
        elseif context.playing_card_added and not self.getting_sliced then
        elseif context.first_hand_drawn then
        elseif context.setting_blind and not self.getting_sliced then
			if self.ability.name == "Buffet" and not context.blueprint then
				self.ability.extra.chips = self.ability.extra.chips + self.ability.extra.chip_mod
				return {
					card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS, card = self})
				}
			end
        elseif context.destroying_card and not context.blueprint then
        elseif context.cards_destroyed then
        elseif context.remove_playing_cards then
        elseif context.using_consumeable then
        elseif context.debuffed_hand then
        elseif context.pre_discard then
        elseif context.discard then
        elseif context.end_of_round then
			if context.individual then
			elseif context.repetition then
			elseif not context.blueprint then
				if self.ability.name == "Dressing Table" then
					local dressable_jokers = {}
					for i = 1, #G.jokers.cards do
						if G.jokers.cards[i] ~=self then dressable_jokers[#dressable_jokers + 1] = G.jokers.cards[i] end
					end
					local eligible_joker = #dressable_jokers > 0 and pseudorandom_element(dressable_jokers, pseudoseed('dressing_table')) or nil
					if pseudorandom('dressing_table') < G.GAME.probabilities.normal/self.ability.extra and eligible_joker ~= nil and eligible_joker:get_edition() == nil then
						if not (context.blueprint_card or self).getting_sliced then
							G.E_MANAGER:add_event(Event({func = function()
								local edition = nil
								edition = poll_edition('dressing_table', nil, true, true)
								eligible_joker:set_edition(edition, true)
								check_for_unlock({type = 'have_edition'})
								card_eval_status_text(self, 'extra', nil, nil, nil, {message = 'Dressup!', colour = G.C.PURPLE})
							return true end}))
						end
					elseif eligible_joker == nil or eligible_joker:get_edition() ~= nil then return nil
					else
						card_eval_status_text(self, 'extra', nil, nil, nil, {message = 'Nope!', colour = G.C.PURPLE})
					end
				end
			end
        elseif context.individual then
			if context.cardarea == G.play then
				if self.ability.name == "Conglomerate Joker" and context.other_card:is_suit(G.GAME.current_round.ancient_card.suit) then
					G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
					G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
					return {
						dollars = self.ability.extra,
						card = self
					}
				end
			end
        elseif context.repetition then
        elseif context.other_joker then
		else
			if context.cardarea == G.jokers then
				if context.before then --context.before/after played hand or nil determines when the joker triggers
					if self.ability.name == "Pay to Win" then
						if G.GAME.dollars >= self.ability.extra then
							ease_dollars(-self.ability.extra)
							return {
								message = "Pay Up!",
								colour = G.C.MONEY
							}
						else
							return nil
						end
					end
				elseif context.after then
				else
					if self.ability.name == "Buffet" then
						return {
							message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips}},
							chip_mod = self.ability.extra.chips,
						}
					end
					if self.ability.name == "Pay to Win" then
						if G.GAME.dollars >= self.ability.extra then
							self.ability.x_mult = 1.5
							return {
								message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}},
								Xmult_mod = self.ability.x_mult
							}
						else
							return nil
						end
					end
					--[[
					if self.ability.name == "Gaggle" then
						card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips}}, colour = G.C.CHIPS})
						card_eval_status_text((context.blueprint_card or self), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra.Xmult}}, colour = G.C.MULT})
						return {
							--message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips, self.ability.extra.Xmult}},
							chip_mod = self.ability.extra.chips,
							Xmult_mod = self.ability.extra.Xmult,
						}
					end
					if self.ability.name == "Connoisseur" then
						if G.GAME.chips >= 200 then
							return {
								message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips, self.ability.extra.Xmult}},
								chip_mod = self.ability.extra.chips,
								Xmult_mod = self.ability.extra.Xmult,
							}
						else
							return {
								message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips, self.ability.extra.Xmult}},
								chip_mod = self.ability.extra.chips,
								Xmult_mod = self.ability.extra.Xmult,
								G.GAME.chips == 0
							}
						end
					end
					]]--
					if self.ability.name == "Archibald" and self.ability.x_mult > 1 then
						self.ability.x_mult = 1.5
						return {
							message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.x_mult}},
							Xmult_mod = self.ability.x_mult
						}
					end
				end
			end
		end
		
		return calc_ref
	end
end

local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
	local card_type, hide_desc = self.ability.set or "None", nil
	local loc_vars = nil
	local main_start, main_end = nil, nil
	local no_badge = nil
	
	if self.config.center.unlocked == false and not self.bypass_lock then
	elseif card_type == "Undiscovered" and not self.bypass_discovery_ui then 
	elseif self.debuff then
	elseif card_type == "Default" or card_type == "Enhanced" then
	elseif self.ability.set == "Joker" then
		local customJoker = true
		
		if self.ability.name == "Buffet" then
			loc_vars = {self.ability.extra.chips, self.ability.extra.chip_mod}
		--[[
		elseif self.ability.name == "Gaggle" then
			loc_vars = {self.ability.extra.chips, self.ability.extra.Xmult}
		elseif self.ability.name == "Connoisseur" then
			loc_vars = {self.ability.extra.chips, self.ability.extra.Xmult}
		]]--
		elseif self.ability.name == "Salesman Joker" then
			loc_vars = {self.ability.extra}
		elseif self.ability.name == "Conglomerate Joker" then
			loc_vars = {self.ability.extra, localize(G.GAME.current_round.ancient_card.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.ancient_card.suit]}}
		elseif self.ability.name == "Dressing Table" then
			loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra}
		elseif self.ability.name == "Pay to Win" then
			loc_vars = {self.ability.x_mult, self.ability.extra}
		elseif self.ability.name == "Archibald" then
			loc_vars = {self.ability.x_mult, self.ability.extra}
		else
			customJoker = false
		end
		
		if customJoker then
			local badges = {}
			if (card_type ~= "Locked" and card_type ~= "Undiscovered" and card_type ~= "Default") or self.debuff then
				badges.card_type = card_type
			end
			if self.ability.set == "Joker" and self.bypass_discovery_ui and (not no_badges) then
				badges.force_rarity = true
			end
			if self.edition then
				if self.edition.type == "negative" and self.ability.consumeable then
					badges[#badges + 1] = "negative_consumable"
				else
					badges[#badges + 1] = (self.edition.type == "holo" and "holographic" or self.edition.type)
				end
			end
			if self.seal then
				badges[#badges + 1] = string.lower(self.seal) .. "_seal"
			end
			if self.ability.eternal then
				badges[#badges + 1] = "eternal"
			end
			if self.pinned then
				badges[#badges + 1] = "pinned_left"
			end
			if self.sticker then
				loc_vars = loc_vars or {}
				loc_vars.sticker = self.sticker
			end
			
			return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
		end
	end
	return generate_UIBox_ability_tableref(self)
end
----------------------------------------------
------------MOD CODE END----------------------
