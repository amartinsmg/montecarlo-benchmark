all: cuda multi-threaded single-threaded

cuda: dir
	nvcc -O3 src/cuda.cu -o debug/cuda

multi-threaded: dir
	gcc -O3 src/multi-threaded.c -fopenmp -o debug/multi-threaded

single-threaded: dir
	gcc -O3 src/single-threaded.c -o debug/single-threaded

dir:
	mkdir -p debug

clean:
	rm debug/*
