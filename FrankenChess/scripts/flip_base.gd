@tool 
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	flip(scene)
	return scene
	

func flip(node):
	if node != null:
		node.rotation.x += PI
