# syntax=docker/dockerfile:1
FROM ubuntu:18.04
RUN apt-get update && apt-get install -y \
    build-essential libsqlite3-dev libboost-all-dev libssl-dev git python-setuptools castxml \
    python-dev python-pygraphviz python-kiwi python-gnome2 ipython libcairo2-dev python3-gi \
    libgirepository1.0-dev python-gi python-gi-cairo gir1.2-gtk-3.0 gir1.2-goocanvas-2.0 python-pip \
    python3-setuptools python3-pygraphviz python3-cairo \
    protobuf-compiler libprotobuf-dev \
 && rm -rf /var/lib/apt/lists/*
RUN pip install pygraphviz pycairo PyGObject pygccxml

RUN mkdir /ndnSIM
RUN cd /ndnSIM \
 && git clone https://github.com/named-data-ndnSIM/ns-3-dev.git ns-3 \
 && git clone https://github.com/named-data-ndnSIM/pybindgen.git pybindgen \
 && git clone --recursive https://github.com/named-data-ndnSIM/ndnSIM.git ns-3/src/ndnSIM

# workaround to revert the namingschema of the ndnsim lib to 3.30.1 instead of 3-dev
RUN cd /ndnSIM/ns-3 \
 && git diff fbb238dc5061ff5e8eed873b84960078fb133e03..173aec9e080c71e75cca67fb3088834a52f4956a > /tmp/patch \
 && git apply -R /tmp/patch \
 && rm -f /tmp/patch

# fix visualizer show faces
COPY fix-visualizer-show-faces.patch /tmp/
RUN cd /ndnSIM/ns-3 \
 && git apply /tmp/fix-visualizer-show-faces.patch

RUN cd /ndnSIM/ns-3 \
 && ./waf configure -d debug \
 && ./waf \
 && ./waf install

# workaround: in case your app is a real app
WORKDIR /
RUN git clone https://github.com/named-data/ndn-cxx \
 && cd ndn-cxx/ \
 && git checkout ndn-cxx-0.7.0 \
 && ./waf configure \
 && ./waf \
 && ./waf install \
 && ldconfig

WORKDIR /
RUN git clone https://github.com/italovalcy/ndvr \
 && cd ndvr/ \
 && ./waf configure --debug \
 && ./waf

WORKDIR /ndvr
