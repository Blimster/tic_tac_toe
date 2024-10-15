FROM dart:stable

# misc
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    nano
RUN echo "alias ll='ls -la'" >> /root/.bashrc

# dart
RUN echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> /root/.bashrc
RUN dart --disable-analytics
RUN dart pub global activate webdev
