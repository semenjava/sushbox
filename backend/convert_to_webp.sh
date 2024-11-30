#!/bin/bash

# Путь к папке с изображениями
IMAGE_DIR="/home/semen/Документы/Sushibox/sushibox/backend/storage/app/public/banner"

# Создать папку для WebP, если её нет
WEBP_DIR="$IMAGE_DIR/webp"
mkdir -p "$WEBP_DIR"

# Перебор всех файлов изображений в папке
for file in "$IMAGE_DIR"/*.{jpg,jpeg,png}; do
  # Пропустить, если файлов нет
  [ -e "$file" ] || continue

  # Получить имя файла без расширения
  filename=$(basename "$file")
  name="${filename%.*}"

  # Конвертировать в WebP
  cwebp -q 80 "$file" -o "$WEBP_DIR/$name.webp"
  echo "Converted: $file -> $WEBP_DIR/$name.webp"
done
