extends TileMapLayer

@onready var player: CharacterBody2D = $"../Player"
# 玩家到达了安全点
signal player_arrived_safe_cell(pos:Vector2)
# 记录玩家上一帧是否在瓦片上（防止重复触发）
var was_on_tile: bool = false

func _ready() -> void:
	print(get_used_cells())

func _physics_process(_delta):
	# 把玩家坐标 转换成 瓦片坐标
	var tile_pos = local_to_map(player.position)
	# 玩家的格子在地图的上一个格子
	tile_pos.y +=1
	var has_tile  = get_cell_tile_data(tile_pos) != null
	if has_tile:
		# 玩家站在瓦片上了
		if !was_on_tile:
			print("check point")
			emit_signal("player_arrived_safe_cell",player.position)
			was_on_tile = true
	else:
		was_on_tile = false
