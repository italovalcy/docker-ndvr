# NDVR docker images

## NDVR Simulation docker image

This is a docker image to run NDVR under ndnSIM simulator. The dockerfile creates a docker image based on ndnSIM 2.8 / ndn-cxx  0.7.0 / NFD  0.7.0 / ns-3 3.30.1, all compiled in debug mode.

To build the docker image:

	docker build -t ndvr-sim:latest .

To run:

	docker run -d --name ndvr1 ndvr-sim:latest tail -f /dev/null
	docker exec -it ndvr1 bash
	rm -rf /root/.ndn && ndnsec-key-gen /ndn; for i in $(seq 0 3); do ndnsec-key-gen  -n /ndn/%C1.Router/Router$i; done
	NS_LOG=ndn.Ndvr:ndn-cxx.nfd.Forwarder ./waf --run "prodcons_ndvr_mcast --duration=10 --wifiRange=60 --distance=50 --numNodes=4"

To use the visualizer:

- Use an approach similar to described here: https://github.com/fam4r/docker-ndnsim#run-with-visualizer

## NDVR Emulation docker image

TBD
