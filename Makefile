# Makefile
default: image

BUILDER_IMAGE := $(or $(BUILDER_IMAGE),hub.docker.com/eraftio/eraftkv)

# build base image from Dockerfile
image:
	docker build -f Dockerfile -t $(BUILDER_IMAGE) .

# generate protobuf cpp source file
gen-protocol-code:
	docker run --rm -v $(realpath .):/eraft-outer hub.docker.com/eraftio/eraftkv:latest protoc --grpc_out /eraft-outer/src/ --plugin=protoc-gen-grpc=/usr/bin/grpc_cpp_plugin -I /eraft-outer/protocol eraftkv.proto
	docker run --rm -v $(realpath .):/eraft-outer hub.docker.com/eraftio/eraftkv:latest protoc --cpp_out /eraft-outer/src/ -I /eraft-outer/protocol eraftkv.proto

build-dev:
	chmod +x utils/build-dev.sh
	@if [ ! -d "grpc" ]; then wget https://eraft.oss-cn-beijing.aliyuncs.com/grpc.tar.gz; tar xzvf grpc.tar.gz; rm -rf grpc.tar.gz; fi
	docker run -it --rm -v  $(realpath .):/eraft hub.docker.com/eraftio/eraftkv:latest /eraft/utils/build-dev.sh

tests:
	echo "TO SUPPORT"
