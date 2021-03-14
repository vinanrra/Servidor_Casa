# This will start lightdm desktop (Lubuntu Desktop)

echo "¿Iniciar o Parar GUI? [Iniciar/Parar]"
read respuesta
case $respuesta in
    Iniciar|iniciar)

      echo "Iniciando interfaz gráfica"
      sudo service lightdm start

    ;;
    Parar|parar)

      echo "Parando interfaz gráfica"
      sudo service lightdm stop

    ;;
    *)

      echo "Respuesta inválida"

    ;;
esac
