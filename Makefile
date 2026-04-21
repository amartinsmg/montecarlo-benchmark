all: benchmark

benchmark: dir
	nvcc -O3 -Xcompiler -fopenmp -Isrc/common -o build/benchmark src/main.cu

dir:
	mkdir -p build

clean:
	rm build/*
