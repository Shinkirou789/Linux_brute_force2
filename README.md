# Linux_brute_force-bash

Este script en **bash** está diseñado para realizar un ataque de fuerza a la contraseña de uno o varios usuarios de linux al mismo tiempo, permitiendote continuar por donde estabas una vez hayas encontrado la contraseña de un usuario.

## Instalación

Para usar este script, primero debes clonar o descargar el repositorio y darle permisos al script:

```bash
git clone https://github.com/Shinkirou789/Linux_brute_force2.git ; cd Linux_brute_force2 ; chmod 0700 linux_fuerza_bruta.sh
```

No es necesario realizar ninguna instalación adicional.

## Uso

1. **Ejecutar el script**: Debes proporcionar el diccionario sobre el cual quieres hacer el ataque, los usuarios en un archivo y la cantidad de hilos que quieras que se usen.
   Ejemplo:

   ```bash
   ./linux_fuerza_bruta.sh /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt usuarios.txt 4
   ```
2. Una vez se encuentre una contraseña te imprimira por pantalla la contraseña y el usuario y te preguntara si deseas continuar. Todas las contraseña y usuarios se iran guardando en un archivo llamado resultado.txt.
