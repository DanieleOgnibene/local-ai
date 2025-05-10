#!/bin/bash

# Load environment variables from .env
set -a
source .env
set +a

# ----      UTILS      ----
function pause() {
  echo -e "\n✅ Press Enter to return to the menu."
  read
}

# ---- OLLAMA Commands ----
function list_models() {
  docker exec -it "$CONTAINER_NAME_OLLAMA" ollama list
  pause
}

function pull_model() {
  echo -e "🌐 Browse models here: https://ollama.com/search\n"
  read -p "Enter model name to pull (e.g. deepseek-coder-v2): " model
  if [[ -n "$model" ]]; then
    echo -e "\n⬇️ Pulling model: $model\n"
    docker exec -it "$CONTAINER_NAME_OLLAMA" ollama pull "$model"
    pause
  else
    echo "⚠️ No model name entered. Returning to menu."
    sleep 1
  fi
}

function select_model() {
  models=($(docker exec "$CONTAINER_NAME_OLLAMA" ollama list | awk '{print $1}' | tail -n +2))

  if [ ${#models[@]} -eq 0 ]; then
    echo "⚠️ No models found."
    return 1
  fi

  echo "Select a model:"
  for i in "${!models[@]}"; do
    echo "  $((i+1))) ${models[$i]}"
  done

  read -p "Enter number [1-${#models[@]}]: " index
  if ! [[ "$index" =~ ^[0-9]+$ ]] || [ "$index" -lt 1 ] || [ "$index" -gt "${#models[@]}" ]; then
    echo "❌ Invalid selection."
    return 1
  fi

  selected_model="${models[$((index-1))]}"
  return 0
}

function delete_model() {
  if select_model; then
    docker exec -it "$CONTAINER_NAME_OLLAMA" ollama rm "$selected_model"
  fi
  pause
}

function chat_with_model() {
  if select_model; then
    echo -e "\n💬 Chatting with: $selected_model"
    echo "Type your prompt. Type 'exit' or 'quit' to return to the menu."
    echo ""

    while true; do
      read -p "> " prompt

      if [[ "$prompt" =~ ^(exit|quit)$ ]]; then
        echo "👋 Exiting chat with $selected_model."
        break
      elif [[ -z "$prompt" ]]; then
        continue
      fi

      echo ""
      docker exec -i "$CONTAINER_NAME_OLLAMA" ollama run "$selected_model" <<< "$prompt"
      echo ""
    done
  fi
  pause
}

# ---- WEBUI Commands ----
function open_webui() {
  local url="http://localhost:${WEBUI_PORT}"
  if command -v xdg-open &> /dev/null; then
    xdg-open "$url"
  elif command -v open &> /dev/null; then
    open "$url"
  else
    echo "Please open $url in your browser manually."
  fi
  pause
}

# ---- MENU ----
function main_menu() {
  while true; do
    echo ""
    echo "========== Ollama & WebUI Manager =========="
    echo "🧠 Ollama:"
    echo "  1) List models"
    echo "  2) Pull a model"
    echo "  3) Delete a model"
    echo "  4) Chat with a model (terminal)"
    echo ""
    echo "🖥️  Open WebUI:"
    echo "  5) Open WebUI in browser (http://localhost:${WEBUI_PORT})"
    echo ""
    echo "  0) Quit"
    echo "============================================"
    read -p "Choose an option [0-5]: " choice
    echo ""

    case $choice in
      1) list_models ;;
      2) pull_model ;;
      3) delete_model ;;
      4) chat_with_model ;;
      5) open_webui ;;
      0) echo "Goodbye!"; break ;;
      *) echo "Invalid choice. Try again." ;;
    esac
  done
}

main_menu
