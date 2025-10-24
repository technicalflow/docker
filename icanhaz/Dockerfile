FROM debian:12
LABEL MAINTAINER 'marek from mysmall.cloud'

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Warsaw

RUN apt-get update -qq && apt-get install -y --no-install-recommends python3 python3-wheel python3-pip curl
RUN pip3 install gunicorn flask --break-system-packages
COPY ipcheck.py /

HEALTHCHECK --interval=1m --timeout=5s CMD curl -f http://localhost/ || exit 1

EXPOSE 80
USER 1000
CMD ["gunicorn", "--bind", "0.0.0.0:80", "ipcheck"]
