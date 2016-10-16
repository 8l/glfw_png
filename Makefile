CFLAGS?=-Os -pedantic -Wall -std=c++11 

all:
	g++ $(CFLAGS) sample.cpp lodepng.cpp /usr/lib/libX11.a -L/usr/lib/ -lXrandr -lXinerama -lXcursor -lXxf86vm -lXrender -lGL -lGLEW -lglfw -lpng   -o sample


clean:
	rm -f sample

