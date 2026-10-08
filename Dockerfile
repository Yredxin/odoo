FROM odoo@sha256:60eb1b5006df85f900e300b6cc120d51ebd979379ee9588340adc2a84ffcd718

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-venv \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/odoo20

RUN python3 -m venv --system-site-packages /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir \
       -r /opt/odoo20/requirements.txt

RUN apt-get purge -y odoo \
    && groupadd --system --gid 101 odoo \
    && useradd --system --uid 101 --gid 101 \
       --home-dir /var/lib/odoo \
       --shell /bin/bash odoo \
    && mkdir -p /var/lib/odoo \
    && chown odoo:odoo /var/lib/odoo

ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /opt/odoo20

USER odoo

ENTRYPOINT ["/opt/venv/bin/python", "/opt/odoo20/odoo-bin"]
