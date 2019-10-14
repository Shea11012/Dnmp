FROM laradock/workspace:2.2-7.2

USER root

# add a non-root user
ARG PUID=1000
ENV PUID=${PUID}
ARG PGID=1000
ENV PGID=${PGID}

# set Timezone
ARG TZ=Asia/Shanghai
ENV TZ ${TZ}

# Node /NVM
ENV NODE_VERSION node
ENV NPM_REGISTRY https://registry.npm.taobao.org
ENV NVM_DIR /home/dnmp/.nvm
ENV NVM_VERSION v0.35.0

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

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
	&& nvm install ${NODE_VERSION} \
	&& nvm alias default ${NODE_VERSION} \
	&& nvm use default \
	&& npm config set registry ${NPM_REGISTRY} \
	&& echo "" >> ~/.bashrc \
	&& echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc \
	&& echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

USER root

RUN echo "" >> ~/.bashrc \
	&& echo 'export NVM_DIR="/home/dnmp/.nvm"' >> ~/.bashrc \
	&& echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

ENV PATH $PATH:$NVM_DIR/versions/node/v${NODE_VERSION}/bin

RUN . ~/.bashrc && npm config set registry ${NPM_REGISTRY} \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www