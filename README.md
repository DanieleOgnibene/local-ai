# 🧠 Ollama + Open WebUI

Easily run [Ollama](https://ollama.com) with GPU support and [Open WebUI](https://github.com/open-webui/open-webui), including a terminal-based interactive manager to handle models and access the web interface.

---

## 🚀 Features

- One-liner setup using Docker Compose
- NVIDIA GPU support via container runtime
- Interactive terminal menu to:
  - List installed models
  - Pull and delete models
  - Chat with a model in the terminal
  - Open Open WebUI in your browser

---

## 🛠 Requirements

- [Docker](https://www.docker.com/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)
- Bash-compatible terminal (Linux/macOS/WSL)

---

## 📦 Setup

1. **Clone the repo**

```bash
git clone https://github.com/your-username/ollama-openwebui-compose.git
cd ollama-openwebui-compose
```

2. **Create your `.env` file**

```bash
cp .env.example .env
```

You can edit `.env` to change container names or port mappings.

3. **Start everything and open the terminal manager**

```bash
./start.sh
```

This script:
- Starts the containers
- Waits for the Ollama API
- Launches the interactive model manager

---

## 🧾 `.env` Configuration

```env
CONTAINER_NAME_OLLAMA=ollama
CONTAINER_NAME_WEBUI=open-webui
WEBUI_PORT=3000
```

---

## 🖥️ Accessing WebUI

Visit [http://localhost:3000](http://localhost:3000) (or change the port in `.env`).

---

## 📚 Documentation & Resources

#### 🧠 Ollama

- 📖 **REST API Docs**:  
  [Ollama REST API on Postman](https://www.postman.com/postman-student-programs/ollama-api/documentation/suc47x8/ollama-rest-api)

- 🧱 **Available Models**:  
  [Ollama Model Search](https://ollama.com/search)

#### 🖥️ Open WebUI

- 📘 **Official Docs**:  
  [Open WebUI Documentation](https://docs.openwebui.com/)

---

## ❓ FAQ

### Can I preload models?

No, but you can use the menu to pull any model you want after startup.

### Can I chat with a model without the web UI?

Yes — use the "Chat with a model" option in the terminal menu.

### Can I change the Open WebUI port?

Yes — update `WEBUI_PORT` in your `.env`.

