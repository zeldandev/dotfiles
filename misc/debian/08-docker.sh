#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script con privilegios de superusuario"
  exit 1
fi

echo "instalando dependencias..."
apt update -y
apt install -y ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Anadir el respositorio de docker al source list
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Actualizar lista de paquetes
echo "Actualizando la lista de paquetes..."
apt update -y

echo "Instalando Docker y sus componentes..."
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Anadiendo el grupo docker y agregando el usuario acutal..."
if ! getent group docker > /dev/null 2>&1; then
  groupadd docker 
fi

usermod -aG docker $USER

# Verificar si el usuario ya está en el grupo "docker"
if id -nG "$SUDO_USER" | grep -qw "docker"; then
  echo "El usuario ya pertenece al grupo 'docker'."
else
  echo "El usuario no pertenece al grupo 'docker'. Reiniciando el script..."
  exit
fi


# Archivo de configuración de Docker
DOCKER_CONFIG_FILE="/etc/docker/daemon.json"

# Crear un respaldo si el archivo ya existe
if [ -f "$DOCKER_CONFIG_FILE" ]; then
    BACKUP_FILE="/etc/docker/daemon.json.bak_$(date +'%Y%m%d%H%M%S')"
    echo "El archivo $DOCKER_CONFIG_FILE ya existe. Creando un respaldo en $BACKUP_FILE..."
    cp "$DOCKER_CONFIG_FILE" "$BACKUP_FILE"
fi

# Crear un nuevo archivo de configuración con la configuración deseada
echo "Creando un nuevo archivo de configuración de Docker..."
cat <<EOF | tee "$DOCKER_CONFIG_FILE" > /dev/null
{
    "log-driver": "local",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}
EOF

# Reiniciar el servicio Docker para aplicar los cambios
echo "Reiniciando el servicio Docker..."
if systemctl restart docker; then
    echo "Docker se ha reiniciado correctamente. El log-driver 'local' está en uso."
else
    echo "Error: No se pudo reiniciar el servicio Docker. Revisa el estado del servicio."
    exit 1
fi

echo "Instalación y configuración de Docker completadas exitosamente."
