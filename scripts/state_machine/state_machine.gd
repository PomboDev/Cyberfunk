class_name StateMachine
extends Node

@onready var current_owner: Node = get_owner()
@export var current_state: State = null
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
	
	if current_state == null and states.size() > 0:
		change_state(states.keys()[0])

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	
	current_state = states[new_state_name.to_lower()]
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
