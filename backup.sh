#!/bin/bash

# 配置变量
SOURCE_DIR="/opt/nifi"           # 要备份的目录
BACKUP_DIR="/opt/nifi-back"           # 备份存储目录
DATE=$(date +"%Y-%m-%d_%H-%M-%S")      # 当前日期时间
BACKUP_FILE="$BACKUP_DIR/backup_nifi_$DATE.tar.gz"  # 压缩文件名

# 创建备份目录（如果不存在）
mkdir -p "$BACKUP_DIR"

# 压缩目录
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# 检查压缩是否成功
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi

# 删除超过指定天数的旧备份（可选）
MAX_AGE=20  # 最大保留天数
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$MAX_AGE -exec rm {} \;
