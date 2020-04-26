#!/bin/bash

# Author: Jehud II
# E-mail: jehud2@hotmail.com

# Este programa utiliza o Kerio VPN Client em sua versão linux, seu objetivo é colocar uma interface mais intuitiva
# para o usuário utilizando o dialog geralmente presente em toda distribuição linux.
#
# Obs.: o script deve ser executado com permissões elevadas, assim como você usuaria o script do Kerio VPN Client

# VARIÁVEIS
kerio_local="/etc/init.d/kerio-kvc"


# Verifica se o usuário tem o dialog instalado
function checkDialog(){
   if which dialog
   then
      clear
      echo -e "\ndialog encontrado..."
      
      # Chama a função callKerioVPNClient
      callKerioVPNClient
   else
      echo -e "\n"
      echo "Esse software usa o app 'dialog' em sua execução,
      porém não foi possível encontrá-lo em seu computador. Logo
      abaixo será solicitado sua senha para fazer a instalação. Caso
      não queira instalar por favor aperta Ctrl+C para cancelar o processo."
      echo -e "\n"
      
      if sudo apt install dialog
      then
         echo -e "\n"
         echo "Execute o aplicativo novamente."
         echo -e "\n"
      else
         break
      fi
   fi

} # end function checkDialog


# Verifica se o cliente tem o Kerio VPN Client instalado, esperase que o mesmo 
# esteja em $kerio_local
function callKerioVPNClient(){
   if [ -f $kerio_local ]
   then
       # exibe as opções ao usuário, utiliza dialog
      opcao=$( dialog --stdout 					\
         --title 		'Kerio VPN Client'			\
         --menu 		'Escolha uma opção'			\
         0 0 0							\
         start		'Iniciar a conexão VPN'			\
         restart		'Reiniciar o serviço' 			\
         reload		'Recarregar o serviço'			\
         stop		'Parar o serviço'			\
         'change config'	'Mudar arquivo de configuração' )
      
      # executa ação conforme opção do cliente
      case $opcao in
         start)   $kerio_local start;;
         restart) $kerio_local restart;;
         reload)  $kerio_local reload;;
         stop)    $kerio_local stop;;
         "change config")	dpkg-reconfigure kerio-control-vpnclient;;
      esac

      # limpa a tela ao terminar
      # clear
   else
      echo -e "\n"
      echo "Parece que o kerio-vpn-client não está presente em seu computador.
      Você pode obtê-lo em http://download.kerio.com/archive/
      Por favor verifique sua instalação e coloque o caminho correto,
      na variável kerio_local."
      echo -e "\n"
   fi
} # end function callKerioVPNClient


# Execução
checkDialog