--- STEAMODDED HEADER
--- MOD_NAME: More Jokers!
--- MOD_ID: moreJoker
--- MOD_AUTHOR: [Selectromoo]
--- MOD_DESCRIPTION: Adds more Jokers to the game!
----------------------------------------------
------------MOD CODE -------------------------

--Joker metadata
function SMODS.INIT.moreJoker()
	local moreJokers = {
		j_buffet = {order = 1, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 4, name = "Buffet", set = "Joker", config = {extra = {chips = 20, chip_mod = 10}}, pos = {x=3,y=10}},
		--j_gaggle = {order = 2, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 4, name = "Gaggle", set = "Joker", config = {extra = {chips = 200, Xmult = 0.5}}, pos = {x=1,y=12}},
		--j_connoisseur = {order = 3, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 2, cost = 5, name = "Connoisseur", set = "Joker", config = {extra = {chips = -200, Xmult = 1.5}}, pos = {x=6,y=5}},
		j_salesman_joker = {order = 4, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 1, cost = 3, name = "Salesman Joker", set = "Joker", config = {extra = 4}, pos = {x=0,y=10}},
		j_conglomerate_joker = {order = 5, unlocked = true, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 3, cost = 8, name = "Conglomerate Joker", set = "Joker", config = {extra = 1}, pos = {x=1,y=4}},
		j_archibald = {order = 6, unlocked = false, discovered = false, blueprint_compat = true, eternal_compat = true, rarity = 4, cost = 20, name = "Archibald", set = "Joker", config = {extra = 0.25}, pos = {x=5,y=8}, soul_pos = {x=5, y=9}, unlock_condition = {type = '', extra = '', hidden = true}}
	}

	local jokerDesc = {
		j_buffet = {
			name = "Buffet",
			text = {"When {C:attention}Blind{} is selected,", "Gains {C:chips}+#2#{} Chips", "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"} --When blind is selected, Gains +20 Chips (Currently +X Chips)
		},
		--[[
		j_gaggle = {
			name = "Gaggle",
			text = {"{C:chips}+#1#{} Chips", "{X:mult,C:white}X#2#{} Mult"} --+300 Chips, X0.5 Mult
		},
		j_connoisseur = {
			name = "Connoisseur",
			text = {"{C:chips}#1#{} Chips", "{X:mult,C:white}X#2#{} Mult"} -- -300 Chips, X1.5 Mult
		},
		]]--
		j_salesman_joker = {
			name = "Salesman Joker",
			text = {"Sells for {C:money}X#1#{} value"} --Sells for x4 value
		},
		j_conglomerate_joker = {
			name = "Conglomerate Joker",
			text = {"Each played card with", "{V:1}#2#{} suit gives", "{C:money}+$#1#{} when scored,", "{s:0.8}suit changes at end of round"} --+$1 for each card played of a specific suit. The suit changes at the end of each round.
		},
		j_archibald = {
			name = "Archibald",
			text = {"Gains {X:mult,C:white}X#2#{} Mult with", "every {C:attention}Shop{} purchase", "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"}, --Starting at x1 Mult, gains x0.25 Mult with every shop purchase.
			unlock = {"{E:1,s:1.3}?????"}
		}
		
	}
	
	addJokersToPools(moreJokers)
	updateLocalization(jokerDesc)
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
				elseif context.after then
				else
					if self.ability.name == "Buffet" then
						return {
							message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips}},
							chip_mod = self.ability.extra.chips,
						}
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
