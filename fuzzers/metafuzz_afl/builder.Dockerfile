# MetaFuzz AFL++ builder for FuzzBench
#
# Same dependencies as stock fuzzers/aflplusplus/builder.Dockerfile.
# Difference: instead of git clone + compile in Dockerfile,
# we COPY local AFL++ source + patches, and fuzzer.py:build() handles
# patch application + compilation at build time.

ARG parent_image
FROM $parent_image

# Dependencies: identical to fuzzers/aflplusplus/builder.Dockerfile
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        python3-dev \
        python3-setuptools \
        automake \
        cmake \
        git \
        flex \
        bison \
        libglib2.0-dev \
        libpixman-1-dev \
        cargo \
        libgtk-3-dev \
        # for QEMU mode
        ninja-build \
        gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev \
        libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev

# Copy version-matched AFL++ source (instead of git clone)
COPY aflpp_src/ /afl/

# Copy patch infrastructure — fuzzer.py:build() applies patches and compiles
COPY patches/ /metafuzz/patches/
COPY apply_patches.py /metafuzz/apply_patches.py
