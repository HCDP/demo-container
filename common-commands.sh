exit # just making sure this doesn't execute

# Build a container:
docker build . -f Dockerfile -t ghcr.io/hcdp/demo-container:mdodge
# The `.` means we're building in the directory that we're currently in.
# The `-f` flag describes which Dockerfile to build from. In our case, it's redundant as the build command defaults to just 
#    "Dockerfile" in the current directory if the flag isn't present.
# The `-t` flag describes what to tag the container as. 
# Optional: add the --no-cache flag before the `.` to prevent caching from being used.

# Copy a container to a different tag:
docker tag ghcr.io/hcdp/demo-container:mdodge ghcr.io/hcdp/demo-container:latest

# Run a container with defaults:
docker run ghcr.io/hcdp/demo-container:latest

# Or jump into an interactive bash session:
docker run -it ghcr.io/hcdp/demo-container:latest bash # `-it` means to launch with an interactive terminal/tty


# Push a container (requires a login step, out of scope for this tutorial):
docker push ghcr.io/hcdp/demo-container:mdodge