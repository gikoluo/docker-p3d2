#
# The doc: https://docs.docker.com/engine/reference/builder/#usage
# Dockerfile-ceser-subscription
# Help from: https://www.eidel.io/2017/07/10/dockerizing-django-uwsgi-postgres/
#

FROM python:3.8-alpine

RUN apk --no-cache add gettext python3-dev build-base git \
           libffi-dev linux-headers pcre-dev postgresql-dev \ 
      && rm -rf /var/cache/apk/*

# postgresql-client

WORKDIR /app

# -- Preload basic pipfiles
COPY requirements_base.txt requirements_base.txt
# -- Install dependencies:
RUN set -ex && pip3 install -r requirements_base.txt

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

#CMD ["uwsgi", "--ini", "/app/project-project/uwsgi.ini"]
#CMD ["gunicorn", "--workers=2", "--bind=0.0.0.0:8000", "project:project"]