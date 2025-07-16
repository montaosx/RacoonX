# 🦝 RacoonX

**RacoonX** es una herramienta ofensiva escrita en **Bash** diseñada para automatizar tareas de reconocimiento y auditoría en redes. Permite detectar hosts activos, identificar servicios, escanear puertos, realizar fuerza bruta SSH y ejecutar técnicas de OSINT mediante Google Dorks. Todo ello con un enfoque modular y ampliable.

---

## 🎯 Objetivos

- Automatizar el reconocimiento de una red objetivo.
- Facilitar la detección de servicios vulnerables o mal configurados.
- Servir como guía de uso de Google Dorks.
- Servir como plataforma base para prácticas de pentesting y laboratorios de formación.

---

## 🧩 Módulos incluidos

- 🔍 **Host Discovery**: detección de hosts activos en un rango calculado automáticamente.
- 🔗 **Port Scan**: escaneo completo de puertos y servicios con Nmap.
- 🧠 **OS Detection**: fingerprinting de sistemas operativos por Ping y TTL.
- 🕵️ **OSINT**: búsqueda de información externa con Google Dorks.
- 🌐 **Fuerza Bruta SSH**: ejecución de ataques de fuerza bruta con Hydra sobre los host con SSH activo.

---

## 🚀 Instalación

```bash
git clone https://github.com/montaosx/RacoonX.git
cd RacoonX
chmod +x racoonx.sh
