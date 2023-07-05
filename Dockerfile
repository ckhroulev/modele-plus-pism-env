FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
# Install system packages
    apt-get update
    apt-get install -y \
    binutils \
    cmake \
    coreutils \
    curl \
    environment-modules \
    g++ \
    gcc \
    gfortran \
    git \
    bzip2 \
    make \
    pkgconf \
    python2 \
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
# Install spack 0.20
    git clone --depth=100 --branch=releases/v0.20 https://github.com/spack/spack.git ~/spack

    . ~/spack/share/spack/setup-env.sh
    spack compiler find
    spack external find
    spack config add config:connect_timeout:600
EOF

RUN <<EOF
# Install OpenMPI
    . ~/spack/share/spack/setup-env.sh
    spack install openmpi@4.1.5
EOF

RUN <<EOF
# Install PETSc
    . ~/spack/share/spack/setup-env.sh
    spack install \
    petsc@3.19.1+double+mpi+shared~fortran~hdf5~hypre~metis \
    ;
EOF

RUN <<EOF
# Install PISM dependencies
    . ~/spack/share/spack/setup-env.sh
    spack install \
    fftw @3.3.10 precision=double ~mpi \
    gsl@2.7.1 \
    netcdf-c@4.4.0 \
    petsc@3.19.1+double+mpi+shared~fortran~hdf5~hypre~metis \
    udunits@2.2.28 \
    ;
EOF

RUN <<EOF
# Install Python, Cython, NumPy
    . ~/spack/share/spack/setup-env.sh

    spack install \
    py-numpy \
    ;
EOF

RUN <<EOF
# Install icebin dependencies mentioned in its CMakeLists.txt (except
# for MPI, PISM, PETSc, Blitz, ibmisc)
# Some Boost libraries are required by ibmisc and icebin, others by CGAL.

    . ~/spack/share/spack/setup-env.sh

    boost="boost @1.82.0 +container +date_time +exception +filesystem +math +mpi +program_options +random +regex +serialization +system +thread"

    spack install \
    ${boost} \
    cgal@4.12 ^eigen@3.3.1 ^${boost} \
    eigen@3.3.1 \
    everytrace@0.2.2 \
    gmp@6.2.1 \
    googletest@1.12.1 \
    mpfr@4.2.0 \
    netcdf-cxx4@4.3.1 \
    proj@4.9.2 \
    tclap@1.2.2 \
    zlib@1.2.13 \
    ;
EOF

RUN <<EOF
# Install Blitz
    git clone -b 1.0.2 https://github.com/blitzpp/blitz.git ~/blitz
    mkdir -p ~/blitz/build

    cmake -S ~/blitz -B ~/blitz/build \
    -DCMAKE_INSTALL_PREFIX=~/local/blitz \
    -DCMAKE_BUILD_TYPE=Release \
    ;

    make -C ~/blitz/build install
    rm -rf ~/blitz
EOF

run <<EOF
# Install netcdf-fortran and curl for modelE
    . ~/spack/share/spack/setup-env.sh

    spack install \
    netcdf-fortran@4.4.4 ^netcdf-c@4.4.0 \
    parallel-netcdf@1.12.3 +fortran ~cxx \
    curl@8.0.1 \
    ;

# ModelE seems to think that if you happen to have libhdf5 in your lib
# directory then you have to link to libcurl. :-{}
EOF

# Install debugging tools
USER root
RUN apt-get update && apt-get install -y gdb valgrind libc6-dbg
USER builder

run <<EOF
    # Set up symlinks to work around some build system issues
    . ~/spack/share/spack/setup-env.sh

    spack view symlink ~/local/spack \
    curl \
    netcdf-c \
    netcdf-cxx4 \
    netcdf-fortran \
    openmpi \
    parallel-netcdf \
    udunits \
    ;
EOF

COPY <<EOF /home/builder/spack-setup.sh
. ~/spack/share/spack/setup-env.sh

    spack load \\
    boost \\
    cgal \\
    eigen \\
    everytrace \\
    fftw \\
    googletest \\
    gsl \\
    netcdf-c \\
    netcdf-cxx4 \\
    openmpi \\
    petsc \\
    proj \\
    py-cython \\
    py-numpy \\
    tclap \\
    udunits \\
    zlib \\
    ;
EOF

# Tell Git that /opt/pism is safe (used by PISM's build system to get PISM's version)
RUN git config --global --add safe.directory /opt/pism

# Load Spack
RUN echo "source ~/spack-setup.sh" >> ~/.bashrc

# Tell everyone where libicebin.so is (needed to run ModelE with icebin)
RUN echo "export LD_LIBRARY_PATH=$HOME/local/icebin/lib" >> ~/.bashrc

RUN echo "cd ~" >> ~/.bashrc
