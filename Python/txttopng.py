from PIL import Image

# XGA resolution
WIDTH = 1024
HEIGHT = 768

img = Image.new("RGB", (WIDTH, HEIGHT))
pixels = img.load()

with open("ReconstructedImage.txt", "r") as f:
    for y in range(HEIGHT):
        for x in range(WIDTH):
            line = f.readline()
            if not line:
                break
            r, g, b = map(int, line.strip().split())
            pixels[x, y] = (r, g, b)

img.save("ReconstructedImage.jpg")