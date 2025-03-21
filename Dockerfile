#
# Dockerfile: Extend WordPress (php8.3-apache) to support MSSQL connections
#
FROM wordpress:php8.3-apache

# Install system dependencies required for building and using MS SQL PHP extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    software-properties-common \
    unixodbc \
    unixodbc-dev \
    build-essential \
    libxml2-dev \
    libssl-dev \
    libtool \
    autoconf \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft’s official GPG key and repository for the ODBC driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list \
        > /etc/apt/sources.list.d/mssql-release.list

# Install the latest ODBC driver (msodbcsql18) and clean up
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql18 \
    && rm -rf /var/lib/apt/lists/*

# Install the Microsoft SQL Server PHP drivers (sqlsrv + pdo_sqlsrv) via PECL
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv
