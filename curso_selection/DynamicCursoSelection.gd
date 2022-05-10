extends Node2D

onready var node_curso = $Curso
onready var sprites_collection = $SpritesCollection

export var vertical_grid_colums := 8

export var debug = false
export var initial_debug = false

export var move_up = "ui_up"
export var move_down = "ui_down"
export var move_right = "ui_right"
export var move_left = "ui_left"

var index_val := 1

var current_index_pos := 0
var nodes_pos := []
var index_ref_pos_nodes := []

# offset grid reference index
var first_grid_index_val := []
var last_grid_index_val := []

# true offset grid reference index
var first_ref_grid_index := []
var last_ref_grid_index := []


func _ready() -> void:
	initialize_curso_selection()


func _input(event: InputEvent) -> void:
	update_curso_position(vertical_grid_colums)


#=========== public function to access the curso index =============
func get_current_curso_index_pos():
	return current_index_pos

#===================================================================

func initialize_curso_selection():
	nodes_pos = generate_position_based_on_node_ref(sprites_collection.get_children())
	index_ref_pos_nodes = generate_index_val_based_on_node_pos(nodes_pos)
	generate_first_last_offset_ref_index(vertical_grid_colums, nodes_pos.size())
	generate_first_last_true_offset_ref_index(vertical_grid_colums)
	set_curso_node_position()
	debug_output_value_generated()


func set_curso_node_position():
	get_node("Curso").position = nodes_pos[current_index_pos]


func loop_search_val_in_array_index(reference_index_p, grid_index_p):
	var count_index_reference := 0
	
	for index_element in reference_index_p:
		if current_index_pos == index_element:
			current_index_pos = grid_index_p[count_index_reference]
		count_index_reference += 1
	is_debug_on()


func generate_position_based_on_node_ref(nodes_p):
	var nodes_pos_arr := []
	var count_el := 0
	
	for n in nodes_p:
		nodes_pos_arr.append(n.position)
		count_el += 1
	return nodes_pos_arr


func generate_index_val_based_on_node_pos(nodes_array):
	var index_val := []
	var count_val_loop := 0
	
	while count_val_loop < nodes_array.size():
		index_val.append(count_val_loop)
		count_val_loop += 1
		
	return index_val


func generate_first_last_offset_ref_index(matrix_grid, index_count):
	var first_index_offset := []
	var last_index_offset := []
	
	var first_offset_count_start := 0
	var last_offset_count_start = index_count - matrix_grid
	
	var count := 0
	while count < matrix_grid:
		first_index_offset.append(first_offset_count_start)
		last_index_offset.append(last_offset_count_start)
		first_offset_count_start += 1
		last_offset_count_start += 1
		count += 1
		
	first_grid_index_val = first_index_offset
	last_grid_index_val = last_index_offset


func generate_first_last_true_offset_ref_index(grid_num):
	var new_array_index_f := []
	var new_array_index_l := []
	
	for index_el_1 in first_grid_index_val:
		var new_val_1 = index_el_1 - grid_num
		new_array_index_f.append(new_val_1)
		
	for index_el_2 in last_grid_index_val:
		var new_val_2 = index_el_2 + grid_num
		new_array_index_l.append(new_val_2)
		
	first_ref_grid_index = new_array_index_f
	last_ref_grid_index = new_array_index_l


func debug_output_value_generated():
	if initial_debug == true:
		print("Grids Column: ", vertical_grid_colums)
		print("Node Position Generated: ", nodes_pos)
		print("Index Reference Position Generated: ", index_ref_pos_nodes)
		print("First Index Reference: ", first_grid_index_val)
		print("Last Index Reference: ", last_grid_index_val)
		print("First Index True Ref: ", first_ref_grid_index)
		print("Last Index True Ref: ", last_ref_grid_index)


func is_debug_on():
	if debug == true:
		print("Current Curso Index Pos: ", current_index_pos)


func update_curso_position(vertical_grid_val):
	var total_index_count = nodes_pos.size()
	var last_index_count = nodes_pos.size() - index_val
	var first_index_pos := 0
	
	if Input.is_action_just_pressed(move_up):
		current_index_pos -= vertical_grid_val
		loop_search_val_in_array_index(first_ref_grid_index, last_grid_index_val)
		set_curso_node_position()
	
	if Input.is_action_just_pressed(move_down):
		current_index_pos += vertical_grid_val
		loop_search_val_in_array_index(last_ref_grid_index, first_grid_index_val)
		set_curso_node_position()
	
	if Input.is_action_just_pressed(move_right):
		current_index_pos += index_val
		if current_index_pos == total_index_count:
			current_index_pos = first_index_pos
		set_curso_node_position()
		is_debug_on()
		
	if Input.is_action_just_pressed(move_left):
		current_index_pos -= index_val
		if current_index_pos < first_index_pos:
			current_index_pos = last_index_count
		set_curso_node_position()
		is_debug_on()
