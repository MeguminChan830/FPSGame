extends Spatial

var mesh_library_path = "res://result/Lib.tres"

func _ready() -> void:
    create_mesh_library()

func create_mesh_library():
    var mesh_library = MeshLibrary.new()
    var children = get_children()  # Get all children of the current node

    for i in range(children.size()):
            var scene_instance = children[i]
            var mesh_instance = find_mesh_instance(scene_instance)
            if mesh_instance:
                var item_id = i
                mesh_library.create_item(item_id)
                mesh_library.set_item_mesh(item_id, mesh_instance.mesh)
                mesh_library.set_item_name(item_id, children[i].name)  # Set the name


                var preview_texture = load("res://models/blue.png")
                if preview_texture:
                    mesh_library.set_item_preview(item_id, preview_texture)
#
                scene_instance.queue_free()
            else:
                print("No MeshInstance found in scene: ", children[i].name)

    # Save the MeshLibrary to a file
    ResourceSaver.save(mesh_library_path, mesh_library)
    print("MeshLibrary saved to: ", mesh_library_path)
    get_tree().quit()

func find_mesh_instance(node):
    if node is MeshInstance:
        return node
    for child in node.get_children():
        if child is MeshInstance:
            return child
    return null
	