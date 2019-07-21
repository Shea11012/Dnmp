FROM ubuntu:19.10

RUN sed -i 's!archive.ubuntu.com!mirrors.aliyun.com!g' /etc/apt/sources.list \
	&& rm -Rf /var/lib/apt/lists/* \
	&& apt-get update && apt-get upgrade -y -m && apt-get install -y \
	apt-utils gcc g++ openssh-server cmake \
	build-essential gdb gdbserver rsync vim \
	&& mkdir /var/run/sshd \
	&& echo 'root:root' | chpasswd \
	&& sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# 22 for ssh server 777 for gdb server
EXPOSE 22 7777

RUN useradd -ms /bin/bash debugger && \
	echo 'debugger:debugger' | chpasswd

CMD ["/usr/sbin/sshd","-D"]