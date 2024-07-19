FROM alpine

ARG DEBIAN_FRONTEND=noninteractive
# Install necessary packages
#RUN yes | apk update && yes | apk upgrade && yes | apk add -y openssh-server python3
RUN apk update
RUN apk add openssh
# Configure SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh && echo "root:password" | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config \
    && ssh-keygen -A \
    && mkdir -p /var/run/sshd

# Expose SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
