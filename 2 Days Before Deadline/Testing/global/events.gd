extends Node

#Card stuff
#@warning_ignore("unused_signal")
#signal disable_reroll_button_requested
@warning_ignore("unused_signal")
signal card_drag_started(card_ui: CardUI)
@warning_ignore("unused_signal")
signal card_drag_ended(card_ui: CardUI)
@warning_ignore("unused_signal")
signal card_aim_started(card_ui: CardUI)
@warning_ignore("unused_signal")
signal card_aim_ended(card_ui: CardUI)
@warning_ignore("unused_signal")
signal card_played(card: Card)
@warning_ignore("unused_signal")
signal card_tooltip_requested(card: Card)
@warning_ignore("unused_signal")
signal tooltip_hide_requested

#Player stuff
@warning_ignore("unused_signal")
signal player_hand_drawn
@warning_ignore("unused_signal")
signal player_hand_discarded
@warning_ignore("unused_signal")
signal player_turn_ended
@warning_ignore("unused_signal")
signal reroll_requested
@warning_ignore("unused_signal")
signal hide_ui_requested
@warning_ignore("unused_signal")
signal show_ui_requested

#Shop stuff
@warning_ignore("unused_signal")
signal shop_item_bought(item: Item, coin_cost: int)
@warning_ignore("unused_signal")
signal shop_card_bought(card: Card, coin_cost: int)
@warning_ignore("unused_signal")
signal shop_exited
