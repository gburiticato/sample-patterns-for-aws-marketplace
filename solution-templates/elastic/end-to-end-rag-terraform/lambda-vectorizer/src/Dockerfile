FROM public.ecr.aws/lambda/python:3.12
ENV PYTHONDONTWRITEBYTECODE=1

COPY fedora.repo /etc/yum.repos.d/
RUN dnf --enablerepo=fedora -y install tesseract
RUN dnf install -y mesa-libGL libglvnd-glx poppler-utils

COPY requirements.txt /tmp/
RUN pip install --no-compile --no-cache-dir -r /tmp/requirements.txt
RUN pip cache purge

COPY . /var/task

CMD ["main.handler"]
