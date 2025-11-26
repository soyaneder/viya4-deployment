#!/usr/bin/env bash

# ==============================================================================
# CONFIGURACIÓN DE VARIABLES
# Reemplaza los valores entre comillas con los nombres reales de tus recursos
# ==============================================================================

# 1. Configuración de AKS (Kubernetes)
AKS_RESOURCE_GROUP="scotia-peru-rg"
AKS_NAME="scotia-peru-aks"

# 2. Configuración de Máquina Virtual (VM)
VM_RESOURCE_GROUP="scotia-peru-rg"
VM_NAME="scotia-peru-jump-vm"

# 3. Configuración de PostgreSQL Flexible Server
DB_RESOURCE_GROUP="scotia-peru-rg"
DB_NAME="scotia-peru-default-flexpsql"

# 4. Tiempo de pausa entre comandos (en segundos)
# Recomendación: 10-15 segundos es suficiente para limpiar el buffer de salida
# ya que el comando de Azure por defecto espera a que la operación termine.
TIEMPO_PAUSA=6

# Función para mostrar barra de progreso
barra_progreso () {
    local duracion=$1
    local block="▇"
    local empty="░"
    local width=30 # Ancho visual de la barra

    echo # Salto de línea inicial
    for (( i=1; i<=duracion; i++ )); do
        # Calcular porcentaje
        local percent=$(( i * 100 / duracion ))
        # Calcular cuántos bloques llenar
        local filled_len=$(( width * i / duracion ))
        local empty_len=$(( width - filled_len ))

        # Construir la barra
        local bar=""
        if [ $filled_len -gt 0 ]; then
            bar=$(printf "%0.s$block" $(seq 1 $filled_len))
        fi
        local spaces=""
        if [ $empty_len -gt 0 ]; then
            spaces=$(printf "%0.s$empty" $(seq 1 $empty_len))
        fi

        # Imprimir la barra usando \r para sobreescribir la línea
        printf "\r⏳ Esperando: [%s%s] %d%% (%ds)" "$bar" "$spaces" "$percent" "$((duracion - i))"
        sleep 1
    done
    echo -e "\n✅ Continuamos...\n"
}

# ==============================================================================
# INICIO DEL SCRIPT
# ==============================================================================

echo "------------------------------------------------------"
echo "Iniciando secuencia de apagado de ambiente SAS Viya..."
echo "------------------------------------------------------"

kubectl create job sas-stop-all-`date +%s` --from cronjobs/sas-stop-all -n viya
barra_progreso $TIEMPO_PAUSA*10*2

echo "------------------------------------------------------"
echo "Iniciando secuencia de apagado de recursos en Azure..."
echo "------------------------------------------------------"

# 1. Apagar AKS
echo "⏳ [1/3] Deteniendo el clúster de AKS: $AKS_NAME..."
az aks stop --resource-group $AKS_RESOURCE_GROUP --name $AKS_NAME --output none
echo "✅ AKS detenido correctamente."

echo "⏸️ Pausando por $TIEMPO_PAUSA segundos..."
barra_progreso $TIEMPO_PAUSA

# 2. Apagar VM
# Nota: Usamos 'deallocate' para asegurar que Azure deje de cobrar por el cómputo.
echo "⏳ [2/3] Desasignando (apagando) la VM: $VM_NAME..."
az vm deallocate --resource-group $VM_RESOURCE_GROUP --name $VM_NAME --output none
echo "✅ VM desasignada correctamente."

echo "⏸️ Pausando por $TIEMPO_PAUSA segundos..."
barra_progreso $TIEMPO_PAUSA

echo "-----------------------------------------------------"
echo "🎉 Todos los recursos han sido apagados exitosamente."
echo "-----------------------------------------------------"