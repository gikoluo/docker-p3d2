#
# The doc: https://docs.docker.com/engine/reference/builder/#usage
# Dockerfile-ceser-subscription
# Help from: https://www.eidel.io/2017/07/10/dockerizing-django-uwsgi-postgres/
#

FROM python:3.8

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
     && sed -i 's|security.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends \
         postgresql-client gettext libgettextpo-dev \
     && rm -rf /var/lib/apt/lists/* \
     && pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple \
     && pip3 config set global.trusted-host mirrors.aliyun.com \
     && pip3 config set global.verify_ssl false \
     && pip3 install uwsgi


WORKDIR /app


# -- Adding Pipfiles
ONBUILD COPY requirements.txt requirements.txt

# -- Install dependencies:
ONBUILD RUN set -ex && pip3 install -r requirements.txt


# -- Adding Pipfiles
ONBUILD COPY requirements_additions.txt requirements_additions.txt

# -- Install dependencies:
ONBUILD RUN set -ex && pip3 install -r requirements_additions.txt


ONBUILD COPY . .

EXPOSE 8000
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

#CMD ["uwsgi", "--ini", "/app/caeser-subscription/uwsgi.ini"]
#CMD ["gunicorn", "--workers=2", "--bind=0.0.0.0:8000", "project:project"]