# Makefile
default: image

BUILDER_IMAGE := $(or $(BUILDER_IMAGE),hub.docker.com/eraftio/eraftkv)

# build base image from Dockerfile
image:
	docker build -f Dockerfile -t $(BUILDER_IMAGE) .

# generate protobuf cpp source file
gen-protocol-code:
	docker run --rm -v $(realpath .):/eraft eraft/eraftkv:v0.0.1 /eraft/build/grpc/third_party/protobuf/protoc --grpc_out /eraft/src/ --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin -I /eraft/protocol eraftkv.proto
	docker run --rm -v $(realpath .):/eraft eraft/eraftkv:v0.0.1 /eraft/build/grpc/third_party/protobuf/protoc --cpp_out /eraft/src/ -I /eraft/protocol eraftkv.proto

# build eraftkv on local machine
build-dev:
	chmod +x utils/build-dev.sh
	@if [ ! -d "grpc" ]; then wget https://eraft.oss-cn-beijing.aliyuncs.com/grpc.tar.gz; tar xzvf grpc.tar.gz; rm -rf grpc.tar.gz; fi
	docker run -it --rm -v  $(realpath .):/eraft eraft/eraftkv:v0.0.1 /eraft/utils/build-dev.sh

tests:
	docker run -it --rm -v  $(realpath .):/eraft eraft/eraftkv:v0.0.1 /eraft/build/gtest_example_tests
	docker run -it --rm -v  $(realpath .):/eraft eraft/eraftkv:v0.0.1 /eraft/build/rocksdb_storage_impl_tests
