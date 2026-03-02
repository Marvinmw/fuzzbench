# MetaFuzz AFL++ builder for FuzzBench
# Copies version-matched AFL++ source + patches; fuzzer.py:build() handles
# patch application, compilation, and benchmark instrumentation.

ARG parent_image
FROM $parent_image

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        python3 \
        python3-dev \
        python3-setuptools \
        automake \
        cmake \
        flex \
        bison \
        libglib2.0-dev \
        libpixman-1-dev \
        cargo \
        libgtk-3-dev \
        ninja-build \
        gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev \
        libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy version-matched AFL++ source (NOT git clone)
COPY aflpp_src/ /afl/

# Copy patch infrastructure — fuzzer.py:build() applies patches and compiles
COPY patches/ /metafuzz/patches/
COPY apply_patches.py /metafuzz/apply_patches.py
