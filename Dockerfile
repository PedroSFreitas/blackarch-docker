FROM archlinux/base
LABEL maintainer="psf@blackarch.org"

USER root:root
ENV HOME /root
WORKDIR /root

COPY build.sh /root/build.sh
RUN chmod a+x /root/build.sh && \
    sh /root/build.sh

CMD ["/bin/zsh"]
