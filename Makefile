all: benchmark

benchmark: dir
	nvcc -O3 -Xcompiler -fopenmp src/benchmark.cu -o debug/benchmark 

dir:
	mkdir -p debug

clean:
	rm debug/*
