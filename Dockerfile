
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizar Ubuntu e instalar paquetes
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio para SSH
RUN mkdir -p /run/sshd

# Crear usuario ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

# Dar permisos sudo sin contraseña
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Permitir autenticacion SSH por contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config

# Generar claves SSH del servidor
RUN ssh-keygen -A

EXPOSE 22

# Mantener SSH funcionando
CMD ["/usr/sbin/sshd", "-D", "-e"]
