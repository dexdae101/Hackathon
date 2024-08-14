extends Node3D

@export var file_name :String = "pino.file"

var file_icons = {
	"application-certificate.svg": ["crt", "pem"],
	"application-x-addon.svg": ["xpi", "crx"],
	"application-x-executable.svg": ["exe", "bin"],
	"application-x-firmware.svg": ["fw", "bin"],
	"application-x-generic.svg": ["bin", "data"],
	"application-x-sharedlib.svg": ["so", "dll"],
	"audio-x-generic.svg": ["mp3", "wav", "ogg"],
	"font-x-generic.svg": ["ttf", "otf"],
	"image-x-generic.svg": ["jpg", "png", "gif"],
	"inode-directory.svg": [""],  # Represents directories, no specific extension
	"inode-symlink.svg": [""],     # Represents symlinks, no specific extension
	"model.svg": ["stl", "obj"],
	"package-x-generic.svg": ["deb", "rpm"],
	"text-html.svg": ["html", "htm"],
	"text-x-generic.svg": ["txt", "md"],
	"text-x-preview.svg": ["preview"],
	"text-x-script.svg": ["sh", "py", "pl"],
	"video-x-generic.svg": ["mp4", "avi", "mkv"],
	"x-office-addressbook.svg": ["vcf"],
	"x-office-document.svg": ["odt", "doc", "docx"],
	"x-office-document-template.svg": ["ott", "dotx"],
	"x-office-drawing.svg": ["odg", "svg"],
	"x-office-presentation.svg": ["odp", "ppt", "pptx"],
	"x-office-presentation-template.svg": ["otp", "potx"],
	"x-office-spreadsheet.svg": ["ods", "xls", "xlsx"],
	"x-office-spreadsheet-template.svg": ["ots", "xltx"],
	"x-package-repository.svg": ["repo"]
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
		file_icons_key = "application-x-generic.svg"

	$Sprite3D.texture = load("res://textures/files/" + file_icons_key)
	$Sprite3D/Label3D.text = file_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = Globals.player.rotation


func _on_area_3d_body_entered(body):
	print(body)
