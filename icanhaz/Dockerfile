FROM debian:10
LABEL maintainer="marek@techfellow.it"

RUN apt-get update -qq && apt-get install -y --no-install-recommends python3 python3-wheel python3-pip curl
RUN pip3 install gunicorn && pip3 install flask
COPY ipcheck.py /

HEALTHCHECK --interval=1m --timeout=5s CMD curl -f http://localhost/ || exit 1

EXPOSE 80
USER 1000
CMD ["gunicorn", "--bind", "0.0.0.0:80", "ipcheck"]
