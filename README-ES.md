# AutoTranscribe

![andalûh2](https://user-images.githubusercontent.com/34275535/231167984-65f9cf1d-6532-4079-aadd-563e2d1f3fe0.png)

AutoTranscribe es un script de AutoHotkey que transcribe la ortografía española a la propuesta de E.P.A. andaluza en tiempo real. El script está diseñado para automatizar el proceso de transcripción y mejorar la eficiencia de la transcripción de texto en andaluz E.P.A. propuesta.

![demo](https://user-images.githubusercontent.com/34275535/231208922-76c18dce-8f64-405c-b2a8-a715ed683dfa.gif)


## Uso
Para usar AutoTranscribe, simplemente ejecute el script en AutoHotkey. Una vez ejecutado el script, transliterará automáticamente y en tiempo real cualquier texto en español que escriba a la propuesta de E.P.A. andaluz.

### Pausa / Reanudar:
- `ctrl`+`alt`+`p` pausará / reanudará el programa
### Transliterar el texto seleccionado: 
- `ctrl`+`alt`+`m` transliterará el texto seleccionado.

Puedes pausar o reanudar el script en cualquier momento pulsando Ctrl+Alt+P.

## Funciones
AutoTranscribe admite actualmente las siguientes funciones:

Transcripción en tiempo real del texto en español a la propuesta de E.P.A. en andaluz.
Funcionalidad de pausa y reanudación con Ctrl+Alt+P.
Funcionalidad de Transcripción de texto seleccionado con Ctrl+Alt+P.
Planeamos añadir más características en el futuro para mejorar aún más la funcionalidad del script.

## Funcionamiento
**Andaluh.ahk / Andaluh.exe :** substitullen las palabras escritas por su equivalente ortografico E.P.A.
Esre fichero se encarga de la logica de substitucion y el manejo y generacion del lemario usado.

**keyboardhook.ahk / keyboardhook.exe :** Se encarga de la logica para las teclas de caracteres y teclas de fin de palabra, asi como los comandos de pausa/reanudar y de transcripcion del texto seleccionado.

**filehandler.ahk / filehandler.exe :** Se encarga de añadir contenido al lemario para aumentar la velocidad y reducir el coste computacional.

**Andaluh-cli.exe :** Aplicacion de linea de comandos. Se encarga de transcribir las palabras o el texto.

**subs.txt :** Lemario de substituciones.


## Requisitos
AutoTranscribe requiere que AutoHotkey esté instalado en su sistema para funcionar. AutoHotkey puede descargarse del sitio web oficial: https://www.autohotkey.com

Pero también puede ejecutarlo como ejecutable independiente:
Descargue el archivo de instalación del último lanzamiento. https://github.com/andalugeeks/autotranscribe/releases/tag/v0.0.5.0
También puede ejecutar los ejecutables independientes sin instalación:
https://github.com/andalugeeks/autotranscribe/tree/main/Compiled y ejecute Andaluh.exe
Los ejecutables tienen que ser colocados en una carpeta sin espacios en el nombre. como por ejemplo C:\Andaluh o C:\Autotranscribe\andaluh

## Instalación
Para instalar AutoTranscribe, simplemente descarga los scripts del repositorio GitHub y ejecúta Andaluh.ahk con AutoHotkey. o descarga el [Instalador](https://github.com/andalugeeks/autotranscribe/releases/tag/v0.0.5.0)

## Contribuir
Agradecemos cualquier contribución a AutoTranscribe. Si tiene alguna sugerencia sobre nuevas funciones o mejoras, no dude en abrir una incidencia o enviar una solicitud de extracción al repositorio de GitHub.
