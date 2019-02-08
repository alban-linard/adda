all:
	gnat pretty -Padda
	gnat test   -Padda
	gnat metric -Padda
	gnat make 	-Padda
	gnat make -Pobj/gnattest/harness/test_driver
	./obj/gnattest/harness/test_runner
clean:
	gnat clean  -Padda
	rm -rf obj/*
	rm -rf lib/*
