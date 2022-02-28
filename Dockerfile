FROM alpine:3.15
RUN apk add --no-cache \
        bash \
        bluez-btmon \
        bluez-deprecated `# hcidump` \
        coreutils `# timeout busybox implementation incompatible` \
        curl `# support/data https://api.macvendors.com/` \
        gawk `# in verbose mode:  %*x formats are not supported` \
        mosquitto-clients \
        tini \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \; \
    && mkdir /monitor-config \
    && chmod a+rwxt /monitor-config `# .public_name_cache`
ENTRYPOINT ["/sbin/tini", "--"]
VOLUME /monitor-config
COPY . /monitor
WORKDIR /monitor
CMD ["bash", "monitor.sh", "-D", "/monitor-config", "-V"]