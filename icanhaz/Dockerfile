FROM debian:10
LABEL maintainer="marek@techfellow.it"

RUN apt update -qq && apt install -y --no-install-recommends python3 python3-pip curl
RUN pip3 install gunicorn && pip3 install flask
COPY icanhaz.py /

HEALTHCHECK --interval=3m --timeout=5s CMD curl -f http://localhost/ || exit 1

EXPOSE 80
CMD ["gunicorn", "--bind", "0.0.0.0:80", "icanhaz:app"]
