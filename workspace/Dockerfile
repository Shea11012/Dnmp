FROM laradock/workspace:latest-7.3

USER root

# switch apt sources to mirrors.aliyun.com
RUN sed -i 's!archive.ubuntu.com!mirrors.aliyun.com!g' /etc/apt/sources.list
RUN sed -i 's!security.ubuntu.com!mirrors.aliyun.com!g' /etc/apt/sources.list

# add a non-root user
ARG PUID=1000
ENV PUID=${PUID}
ARG PGID=1000
ENV PGID=${PGID}

# set Timezone
ARG TZ=Asia/Shanghai
ENV TZ ${TZ}

# Node /NVM
ARG NODE_VERSION=v14.7.0
ARG NPM_REGISTRY=https://registry.npm.taobao.org
ARG NVM_DIR=/home/dnmp/.nvm
ARG NVM_VERSION=v0.35.3

# composer
ARG COMPOSER_REPO_PACKAGIST=https://mirrors.aliyun.com/composer/

RUN apt-get update -yqq \
	&& apt-get install unzip \
	&& pecl channel-update pecl.php.net \
	&& groupadd -g ${PGID} dnmp \
	&& useradd -u ${PUID} -g dnmp -m dnmp -G docker_env \
	&& usermod -p "*" dnmp \
	&& ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

USER root

COPY ./composer.json /home/dnmp/.composer/composer.json

RUN chown -R dnmp:dnmp /home/dnmp/.composer

USER dnmp

RUN composer global install \
	&& composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST} \
	&& echo "" >> ~/.bashrc \
	&& echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
	&& nvm install ${NODE_VERSION} \
	&& nvm alias default ${NODE_VERSION} \
	&& nvm use default \
	&& npm config set registry ${NPM_REGISTRY} \
	&& echo "" >> ~/.bashrc \
	&& echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
	&& echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

RUN echo "" >> ~/.bashrc \
	&& echo 'export NVM_DIR="/home/dnmp/.nvm"' >> ~/.bashrc \
	&& echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

ENV PATH $PATH:$NVM_DIR/versions/node/v${NODE_VERSION}/bin

USER root
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www