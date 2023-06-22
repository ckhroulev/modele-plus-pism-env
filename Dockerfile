FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
    apt-get update
    apt-get install -y \
    binutils \
    cmake \
    coreutils \
    environment-modules \
    g++ \
    gcc \
    gfortran \
    git \
    bzip2 \
    make \
    pkgconf \
    python3 \
    tar \
    xz-utils \
    ;
# Clean up to reduce the image size:
    rm -rf /var/lib/apt/lists/*
EOF

# Add a user: we don't need to do anything else as root.
RUN useradd --create-home --system --shell=/bin/false builder && usermod --lock builder
USER builder

# Install spack
RUN <<EOF
    git clone --depth=100 --branch=releases/v0.20 https://github.com/spack/spack.git ~/spack

    . ~/spack/share/spack/setup-env.sh
    spack compiler find
    spack external find
EOF

# OpenMPI
RUN . ~/spack/share/spack/setup-env.sh; \
    spack install openmpi@4.1.5

COPY <<EOF /home/builder/spack-setup.sh
. ~/spack/share/spack/setup-env.sh
spack load \\
    blitz \\
    boost \\
    cgal \\
    eigen \\
    everytrace \\
    gmp \\
    ibmisc \\
    mpfr \\
    netcdf-cxx4 \\
    openmpi \\
    petsc \\
    proj \\
    zlib \\
    ;
EOF

RUN echo "source ~/spack-setup.sh" >> ~/.bashrc
