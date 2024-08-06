#!/bin/bash

# Agregar la clave GPG del repositorio
echo "Agregando la clave GPG del repositorio OpenNebula..."
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg

# Agregar el repositorio de OpenNebula y actualizar
echo "Agregando el repositorio de OpenNebula y actualizando..."
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.8/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update

# Instalar dependencias
echo "Instalando dependencias..."
curl 'https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip' | zcat >/usr/bin/terraform
chmod 0755 /usr/bin/terraform

apt-get install -y python3-pip
apt-get install -y python3-cryptography python3-jinja2
pip3 install 'ansible>=2.8.0,<2.10.0'

# Instalar OpenNebula
echo "Instalando OpenNebula..."
apt-get install -y opennebula opennebula-sunstone opennebula-fireedge opennebula-gate opennebula-flow opennebula-provision

# Habilitar y arrancar los servicios de OpenNebula
echo "Habilitando y arrancando los servicios de OpenNebula..."
systemctl enable --now opennebula opennebula-sunstone

# Cambiar contraseña del usuario oneadmin
echo "Cambiando la contraseña del usuario oneadmin..."
echo 'oneadmin:oneadmin' | chpasswd

# Agregar a oneadmin al archivo sudoers
echo "Agregando a oneadmin al archivo sudoers..."
echo 'oneadmin ALL=(ALL) ALL' >> /etc/sudoers

echo "Instalación completada."
