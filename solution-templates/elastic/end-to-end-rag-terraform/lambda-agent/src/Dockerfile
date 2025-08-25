FROM public.ecr.aws/lambda/python:3.12
ENV PYTHONDONTWRITEBYTECODE=1

COPY requirements.txt /tmp/
RUN pip install --no-compile --no-cache-dir -r /tmp/requirements.txt
RUN pip cache purge

COPY . /var/task

CMD ["main.handler"]
