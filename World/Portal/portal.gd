extends Node2D

const INTERVAL_MSEC = 3000

var showing_data = false
var items_eaten: Dictionary[int, String]


func _physics_process(_delta: float) -> void:
    if showing_data:
        DebugDraw2D.set_text("PORTAL", items_last_interval())


func _on_area_body_entered(body: Node2D) -> void:
    if body is Item:
        items_eaten[Time.get_ticks_msec()] = body.data.name
        body.queue_free()


func items_last_interval() -> Dictionary[String, int]:
    var item_list: Dictionary[String, int]
    for time in items_eaten:
        var time_since_eaten = Time.get_ticks_msec() - time
        if time_since_eaten < INTERVAL_MSEC:
            var item_name = items_eaten[time]
            if item_list.has(item_name):
                item_list[item_name] += 1
            else:
                item_list[item_name] = 1
        else:
            items_eaten.erase(time)
    return item_list


func _on_area_mouse_entered() -> void:
    showing_data = true


func _on_area_mouse_exited() -> void:
    showing_data = false
