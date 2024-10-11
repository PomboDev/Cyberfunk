class_name StateMachine
extends Node

var current_state: State = null
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
	
	if states.size() > 0:
		change_state(states.keys()[0])

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	
	current_state = states[new_state_name]
	current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event):
	if current_state:
		current_state.handle_input(event)
