# Here we select our base image - in this case, the latest LTS version of Ubuntu.
# Note that the repository and org are omitted since this is an official image on Docker Hub.
# Currently, all containerized workflows in the HCDP inherit from ghcr.io/ikewai/task-base:latest
FROM ubuntu:latest


# --- OS-Level Packages --- #
# Refresh the package index.
RUN apt-get update

# Get the GNU C compiler for hello.c
RUN apt-get install -y gcc

# Get python for hello.py, and pip since we may need some packages
RUN apt-get install -y python3 python3-pip

# Get R for hello.R
# This one is a bit tricky because the r-base installer is designed for interactive terminals.
# We can get around it by setting the DEBIAN_FRONTEND environment variable (on debian-based containers).
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y r-base

# Get wget for pulling files
RUN apt-get install -y wget


# --- Language-Level Packages --- #

# Python package installations look like this:
RUN python3 -m pip install numpy

# And R ones looks like this. This specific CRAN mirror was chosen as it's geographically close to our VM.
RUN R -e 'install.packages("spatial", repos="https://ftp.ussg.iu.edu/CRAN/")'


# --- File Inclusions --- #
# Let's bring in our example applications.
RUN mkdir -p /example-applications
ADD example-applications/hello.c /example-applications/hello.c
ADD example-applications/hello.py /example-applications/hello.py
ADD example-applications/hello.R /example-applications/hello.R
# Now let's bring in our default control script. In the current HCDP containers, this is named task.sh.
RUN mkdir -p /control-scripts
ADD task.sh /control-scripts/task.sh


# --- Build-Time Scripts --- #
# Sometimes we need to pull files from somewhere else at build-time.
# We also may need to compile code, such as hello.c.

# Make a directory then download a file to that directory.
RUN mkdir -p /important-files
RUN wget https://example.com/index.html -O /important-files/resource.html

# Compile and link hello.c into an executable.
# It might be easiest to just cd into the directory first.
WORKDIR /example-applications
RUN gcc hello.c -o hello


# --- Final Settings --- #
# The last-used WORKDIR becomes the default directory in the container.
WORKDIR /control-scripts

# The CMD parameter defines what to do when the container is launched without a program specified in CLI.
CMD [ "/bin/bash", "/control-scripts/task.sh" ]