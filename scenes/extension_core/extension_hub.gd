extends Node
class_name GlobalExtensionHub

var docks: Dictionary[String, Node]

func connect_to_port(dock_id: String, port: String, callable: Callable, flags: int = 0) -> void:
	docks[dock_id].connect(port, callable, flags)

func is_connected_to_port(dock_id: String, port: String, callable: Callable) -> bool:
	return docks[dock_id].is_connected(port, callable)

func disconnect_from_port(dock_id: String, port: String, callable: Callable) -> void:
	docks[dock_id].disconnect(port, callable)

func get_docks() -> Array[String]:
	return docks.keys()

func get_ports(dock_id: String) -> Array[String]:
	return docks[dock_id].get_signal_list().map(func(dict): return dict["name"])

func get_port_connections(dock_id: String, port: String) -> Array[Dictionary]:
	return docks[dock_id].get_signal_connection_list(port)

func dock(id: String, object: Node) -> void:
	docks[id] = object

func undock(id: String) -> void:
	if has_dock(id): docks.erase(id)

func has_dock(id: String) -> bool:
	return docks.has(id)

func has_port(dock_id: String, port: String) -> bool:
	return docks[dock_id].get_signal_list().any(func(dict): return dict["name"] == port)
