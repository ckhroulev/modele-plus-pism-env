FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
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
# Install icebin dependencies mentioned in its CMakeLists.txt (except
# for MPI, PISM, PETSc, Blitz, ibmisc, Python, Cython, NumPy)
    . ~/spack/share/spack/setup-env.sh

    spack install \
    boost @1.82.0 +date_time +filesystem +mpi +program_options +regex +serialization +system +thread \
    cgal@5.4.1 \
    eigen@3.4.0 \
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
# Install dependencies of ibmisc so we can build it later
# This will bring in some icebin dependencies as well
    . ~/spack/share/spack/setup-env.sh

    spack install --only dependencies ibmisc@0.1.0
EOF

RUN <<EOF
# Install PISM dependencies
    . ~/spack/share/spack/setup-env.sh
    spack install \
    fftw @3.3.10 precision=double ~mpi \
    gsl@2.7.1 \
    netcdf-c@4.9.2 \
    petsc@3.19.1+double+mpi+shared~fortran~hdf5~hypre~metis \
    udunits@2.2.28 \
    ;
EOF

RUN <<EOF
#Install blitz
    prefix=$HOME/local/blitz
    build_dir=$HOME/local/build/blitz
    mkdir -p ${build_dir}
    cd ${build_dir}
    git clone https://github.com/blitzpp/blitz.git .
    git checkout -b release-1.0.2 1.0.2
    mkdir build
    cmake -DCMAKE_INSTALL_PREFIX=${prefix} \
    -DCMAKE_BUILD_TYPE=Release \
    -S . -B build
    make -C build install
EOF

# Don't touch the stuff above this line!

RUN <<EOF
# Create filesystem views (if absolutely necessary)
    . ~/spack/share/spack/setup-env.sh
    spack view symlink ~/local/cgal cgal
EOF

COPY <<EOF /home/builder/spack-setup.sh
. ~/spack/share/spack/setup-env.sh
spack load \\
    openmpi \\
    petsc \\
    boost \\
    cgal \\
    eigen \\
    netcdf-cxx4 \\
    proj \\
    zlib \\
    ;
EOF
    # blitz \\
    # boost \\
    # cgal \\
    # eigen \\
    # everytrace \\
    # gmp \\
    # ibmisc \\
    # mpfr \\
    # netcdf-cxx4 \\
    # petsc \\
    # proj \\
    # zlib \\

RUN echo "source ~/spack-setup.sh" >> ~/.bashrc
