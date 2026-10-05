FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    samba-common-tools \
    samba-server \
    shadow

ENV BACKUPDIR=/backups

COPY samba.conf /etc/samba/smb.conf
COPY template_quota /tmp/template_quota
COPY --chmod=0755 entrypoint /entrypoint
RUN testparm -s /etc/samba/smb.conf >/dev/null && mkdir -p ${BACKUPDIR}

VOLUME ["/backups"]

EXPOSE 445/tcp

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD smbcontrol smbd ping || exit 1

ENTRYPOINT ["/entrypoint"]

