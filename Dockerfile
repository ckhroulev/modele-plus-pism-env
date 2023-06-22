FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y \
    binutils \
    cmake \
    coreutils \
    environment-modules \
    g++ \
    gcc \
    gfortran \
    git \
    lbzip2 \
    make \
    python3 \
    xz-utils \
    ; \
    rm -rf /var/lib/apt/lists/*

# Add a user: we don't need to do anything else as root.
RUN useradd --create-home --system --shell=/bin/false builder && usermod --lock builder
USER builder

# Install spack
RUN git clone --depth=100 --branch=releases/v0.20 https://github.com/spack/spack.git ~/spack

RUN . ~/spack/share/spack/setup-env.sh; \
    spack compiler find \
    spack external find \
    ;

RUN . ~/spack/share/spack/setup-env.sh; \
    spack install \
    openmpi@4.1.5 \
    ;

RUN . ~/spack/share/spack/setup-env.sh; \
    spack install \
    petsc@3.19.1+double+mpi+shared~fortran~hdf5~hypre~metis~superlu-dist \
    ;

RUN . ~/spack/share/spack/setup-env.sh; \
    spack install \
    blitz@1.0.2 \
    boost@1.82.0+filesystem+date_time \
    cgal@5.4.1 \
    eigen@3.4.0 \
    proj@4.9.2 \
    zlib@1.2.13 \
    ;

RUN . ~/spack/share/spack/setup-env.sh; \
    spack install \
    everytrace@0.2.2 \
    ;

COPY <<EOF ~/spack-setup.sh
#!/bin/sh
. ~/spack/share/spack/setup-env.sh
spack load \
    blitz \
    boost \
    cgal \
    eigen \
    everytrace \
    gmp \
    ibmisc \
    mpfr \
    netcdf-cxx4 \
    openmpi \
    petsc \
    proj \
    zlib \
    ;
EOF

RUN echo "source ~/spack-setup.sh" >> ~/.bashrc
