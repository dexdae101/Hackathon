extends Node3D

@export var file_name :String = "pino.zip"
@export var file_size :int = 5000			#KB
var sprite_texture_image :Image
var hp :int = file_size

var file_icons = {
	"application-certificate.png": ["crt", "pem"],
	"application-x-addon.png": ["xpi", "crx"],
	"application-x-executable.png": ["exe", "bin"],
	"application-x-firmware.png": ["fw", "bin"],
	"application-x-generic.png": ["bin", "data"],
	"application-x-sharedlib.png": ["so", "dll"],
	"audio-x-generic.png": ["mp3", "wav", "ogg"],
	"font-x-generic.png": ["ttf", "otf"],
	"image-x-generic.png": ["jpg", "png", "gif"],
	"inode-directory.png": [""],  # Represents directories, no specific extension
	"inode-symlink.png": [""],     # Represents symlinks, no specific extension
	"model.png": ["stl", "obj"],
	"package-x-generic.png": ["deb", "rpm", "zip", "rar", "7zip"],
	"text-html.png": ["html", "htm"],
	"text-x-generic.png": ["txt", "md"],
	"text-x-preview.png": ["preview"],
	"text-x-script.png": ["sh", "py", "pl"],
	"video-x-generic.png": ["mp4", "avi", "mkv"],
	"x-office-addressbook.png": ["vcf"],
	"x-office-document.png": ["odt", "doc", "docx"],
	"x-office-document-template.png": ["ott", "dotx"],
	"x-office-drawing.png": ["odg", "png"],
	"x-office-presentation.png": ["odp", "ppt", "pptx"],
	"x-office-presentation-template.png": ["otp", "potx"],
	"x-office-spreadsheet.png": ["ods", "xls", "xlsx"],
	"x-office-spreadsheet-template.png": ["ots", "xltx"],
	"x-package-repository.png": ["repo"]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var file_ext = file_name.split('.')[-1]
	var file_icons_key

	for key in file_icons:
		if file_ext in file_icons[key]:
			file_icons_key = key
			break
	if file_icons_key == null:
		file_icons_key = "application-x-generic.png"

	$Sprite3D.texture = load("res://textures/files/" + file_icons_key)
	sprite_texture_image = Image.load_from_file("res://textures/files/" + file_icons_key)
	$Sprite3D/Label3D.text = file_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = Globals.player.rotation


func _on_area_3d_body_entered(body):
	hurt(10)

func hurt(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
	else:
		for f in range((damage)):
			var pixel_x = randi_range(1, sprite_texture_image.get_width())
			var pixel_y = randi_range(1, sprite_texture_image.get_height())
			var color = Color(randf(), randf(), randf())
			var pixel_dim = randi_range(10, 50)
			for i in range(pixel_dim):
				for j in range(pixel_dim):
					if sprite_texture_image.get_pixel(pixel_x + i, pixel_y + j) != Color(1, 1, 1, 0):
						sprite_texture_image.set_pixel(pixel_x + i, pixel_y + j, color)
		$Sprite3D.texture = ImageTexture.create_from_image(sprite_texture_image)