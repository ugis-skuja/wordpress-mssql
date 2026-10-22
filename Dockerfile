FROM wordpress:php8.5-apache

RUN set -eux; \
    a2enmod headers; \
    \
    . /etc/os-release; \
    curl -fsSL \
      "https://packages.microsoft.com/config/debian/${VERSION_ID%%.*}/packages-microsoft-prod.deb" \
      -o /tmp/packages-microsoft-prod.deb; \
    dpkg -i /tmp/packages-microsoft-prod.deb; \
    rm /tmp/packages-microsoft-prod.deb; \
    \
    apt-get update; \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
      msodbcsql18=18.7.1.1-1 \
      unixodbc-dev \
      libgssapi-krb5-2; \
    \
    pecl install \
      sqlsrv-5.13.3 \
      pdo_sqlsrv-5.13.3; \
    docker-php-ext-enable sqlsrv pdo_sqlsrv; \
    \
    php --ri sqlsrv; \
    php --ri pdo_sqlsrv; \
    odbcinst -q -d; \
    \
    rm -rf /tmp/pear /var/lib/apt/lists/*
