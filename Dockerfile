# Build the ipvs-node-controller binary
FROM golang:1.13 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum

# Copy the go source
COPY main.go main.go
COPY controllers/ controllers/
COPY pkg/ pkg/

# Build ipvs-node-controller
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o ipvs-node-controller main.go

# Build image
FROM docker.m8s.io/medallia/centos-base:v1.3.2-centos76

RUN yum install -y iptables net-tools iproute 

WORKDIR /
COPY --from=builder /workspace/ipvs-node-controller .
ENTRYPOINT ["/ipvs-node-controller"]
