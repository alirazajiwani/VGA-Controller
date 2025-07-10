from PIL import Image

# Load and resize image to 1024x768
img = Image.open("SourceImage.jpg").convert("RGB").resize((1024, 768))

with open("SourceImage.hex", "w") as f:
    for y in range(768):
        for x in range(1024):
            r, g, b = img.getpixel((x, y))
            f.write(f"{r:02X}{g:02X}{b:02X}\n")
