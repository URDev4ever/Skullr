<p align="center">
  <img width="555" height="536" alt="image (28)" src="https://github.com/user-attachments/assets/5c4cd7b1-31db-4366-99e7-7c16a6f7bdef" />
</p>

<h1 align="center">SKULLR – Escáner Web Avanzado con FFUF v3.3</h1>
<p align="center">
  🇺🇸 <a href="README.md"><b>English</b></a> |
  🇪🇸 <b>Español</b>
</p>

**SKULLR** es un *wrapper* totalmente automatizado sobre **FFUF**, diseñado para mejorar el descubrimiento de contenido web.
Incluye instalación automática, detección de protocolo, gestión de wordlists, comprobación de falsos positivos, reportes estructurados y descubrimiento de subdominios, todo en un solo comando.

Creado por **URDev**.

---

## **✨ Características**

* **Instalador con un solo comando** (`./skullr.sh install`)
* **Comando global** (`skullr <objetivo>`)
* **Detección automática de HTTP/HTTPS**
* **Detección de códigos de estado** (200/301/302)
* **Validación de falsos positivos**
* **Integración local con SecLists**
* **Wordlists limpias y optimizadas**
* **Fuzzing de directorios, archivos y extensiones**
* **Descubrimiento de subdominios**
* **Estructura de reportes organizada por escaneo**
* **User-Agent personalizado**
* **Banner ASCII de calavera, porque el estilo importa**

---

## **📦 Instalación**

```bash
git clone https://github.com/URDev4ever/Skullr.git
chmod +x skullr.sh
./skullr.sh install
```

Esto hará lo siguiente:

* Eliminar instalaciones antiguas
* Instalar o verificar dependencias (**ffuf**, **SecLists**)
* Crear el comando global `skullr` en `/usr/local/bin`
* Copiar el script principal al sistema
* Dar permisos de ejecución a todo

Después de esto, podrás ejecutar SKULLR desde cualquier ubicación.

---

## **🚀 Uso**

### **Escaneo básico**

```bash
skullr example.com
```

### **Escaneos con detección de protocolo**

```bash
skullr https://target.com
skullr http://target.com
```

### **Banner de ayuda**

```bash
skullr
```

---

## **📁 Estructura de salida**

Cada escaneo crea su propio directorio con marca de tiempo:

```
~/scans/<objetivo>_<timestamp>/
│
├── results/        # Archivos de salida de FFUF
├── wordlists/      # Copias limpias de las listas necesarias
├── logs/           # Logs de curl, copias y detección de protocolo
└── temp/           # Datos temporales de ejecución
```

Esto garantiza un almacenamiento ordenado y una revisión sencilla de múltiples objetivos.

---

## **🧠 Cómo funciona (visión técnica)**

### **1. Detección de protocolo**

SKULLR primero prueba:

1. `https://objetivo/`
2. `http://objetivo/`

Selecciona el que responda con un código válido **2xx/3xx**.

### **2. Detección de falsos positivos**

Envía varias solicitudes aleatorias para detectar respuestas comodín
(por ejemplo, `200` en rutas inexistentes).
Si se detecta, SKULLR te avisa antes de iniciar el fuzzing.

### **3. Preparación de wordlists**

Para cada archivo esencial de SecLists:

* Se eliminan los comentarios
* Se eliminan líneas vacías
* Se limita la longitud para mejorar el rendimiento
* Se elimina ruido de licencias (listas DirBuster)

Si una wordlist no existe localmente, SKULLR crea un reemplazo mínimo.

### **4. Descubrimiento de subdominios**

Utiliza `subdomains-top1million-110000.txt` de SecLists,
o recurre a una lista mínima integrada.

### **5. Ejecuciones de FFUF**

Fuzzing de directorios, archivos, extensiones y más.
Los resultados se guardan en `results/`.

---

## **🔧 Requisitos**

* **bash**
* **ffuf** (instalado automáticamente en sistemas apt/pacman/brew)
* **curl**
* **SecLists** (instalado automáticamente en sistemas apt)

Funciona en:

* Debian / Ubuntu / Kali
* Arch / Manjaro
* macOS
* Termux (SecLists requiere instalación manual)

---

## **📝 Ejemplo**

```bash
skullr testphp.vulnweb.com
```

Crea:

```
~/scans/testphp.vulnweb_com_20250101_153300/
```

Con todas las wordlists, logs y resultados organizados automáticamente.

---

## **❗ Notas**

* Los privilegios de root solo son necesarios para la instalación (escritura en `/usr/local/bin`).
* Escanear sin autorización es ilegal. Usa SKULLR únicamente en sistemas que poseas o para los que tengas permiso explícito.
* El escaneo 3/5 es **MASIVO**, ten en cuenta que tomará mucho tiempo.
* SKULLR está probado principalmente en Linux.
  macOS está totalmente soportado.
  Termux: usar con rutas ajustadas.

---

hecho con <3 por URDev
