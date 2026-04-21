all: benchmark

benchmark: dir
	nvcc -O3 -Xcompiler -fopenmp src/benchmark.cu -o build/benchmark 

dir:
	mkdir -p build

clean:
	rm build/*
