FROM laradock/workspace:2.2-7.2

USER root

# add a non-root user
ARG PUID=1000
ENV PUID=${PUID}
ARG PGID=1000
ENV PGID=${PGID}

RUN apt-get update -yqq && \
	pecl channel-update pecl.php.net && \
	groupadd -g ${PGID} dnmp && \
	useradd -u ${PUID} -g dnmp -m dnmp -G docker_env && \
	usermod -p "*" dnmp

# set Timezone
ARG TZ=Asia/Shanghai
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# composer

USER root

COPY ./composer.json /home/dnmp/.composer/composer.json

RUN chown -R dnmp:dnmp /home/dnmp/.composer

USER dnmp

RUN composer global install

ARG COMPOSER_REPO_PACKAGIST=https://laravel-china.org/composer
ENV COMPOSER_REPO_PACKAGIST ${COMPOSER_REPO_PACKAGIST}

RUN composer config -g repo.packagist composer ${COMPOSER_REPO_PACKAGIST}

RUN echo "" >> ~/.bashrc && \
	echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc



# Node /NVM
ARG NODE_VERSION=node
ENV NODE_VERSION ${NODE_VERSION}
ARG NPM_REGISTRY=https://registry.npm.taobao.org
ENV NPM_REGISTRY ${NPM_REGISTRY}
ENV NVM_DIR /home/dnmp/.nvm

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash \
	&& . $NVM_DIR/nvm.sh \
	&& nvm install ${NODE_VERSION} \
	&& nvm alias default ${NODE_VERSION} \
	&& nvm use default \
	&& npm config set registry ${NPM_REGISTRY}

RUN echo "" >> ~/.bashrc && \
	echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
	echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

USER root

RUN echo "" >> ~/.bashrc && \
	echo 'export NVM_DIR="/home/dnmp/.nvm"' >> ~/.bashrc && \
	echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc

ENV PATH $PATH:$NVM_DIR/versions/node/v${NODE_VERSION}/bin

RUN . ~/.bashrc && npm config set registry ${NPM_REGISTRY}

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www