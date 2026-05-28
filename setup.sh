#!/bin/bash

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============ 用户自定义配置 ============
SUB_NAME="My-VPN"        # Clash 订阅显示的名称
# =======================================

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}    VLESS-Reality + Clash 订阅一键脚本${NC}"
echo -e "${BLUE}========================================${NC}"

# 检查是否为 root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}请使用 root 权限运行: sudo bash $0${NC}"
    exit 1
fi

# 获取服务器 IP
SERVER_IP=$(curl -s ifconfig.me)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
fi

echo -e "${GREEN}服务器 IP: $SERVER_IP${NC}"

# ============================================
# 第一步：安装 Xray + VLESS-Reality
# ============================================
echo -e "${BLUE}[1/5] 安装 Xray 和 VLESS-Reality...${NC}"

# 生成随机端口
RANDOM_PORT=$((RANDOM % 40000 + 10000))
# 生成随机 UUID
UUID=$(cat /proc/sys/kernel/random/uuid)

# 检查 Xray 是否已安装
if command -v xray &> /dev/null || [ -f /usr/local/bin/xray ]; then
    echo -e "${GREEN}✓ Xray 已安装，跳过安装步骤${NC}"
else
    echo -e "${YELLOW}正在安装 Xray...${NC}"
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
fi

# 等待安装完成
sleep 2

# 生成 Reality 密钥对
echo -e "${YELLOW}正在生成 Reality 密钥对...${NC}"

# 查找 xray 命令的实际路径
XRAY_CMD=""
if command -v xray &> /dev/null; then
    XRAY_CMD=$(command -v xray)
elif [ -f /usr/local/bin/xray ]; then
    XRAY_CMD="/usr/local/bin/xray"
elif [ -f /usr/local/sbin/xray ]; then
    XRAY_CMD="/usr/local/sbin/xray"
elif [ -f /usr/bin/xray ]; then
    XRAY_CMD="/usr/bin/xray"
fi

if [ -z "$XRAY_CMD" ]; then
    echo -e "${RED}未找到 xray 命令，请先安装 Xray${NC}"
    exit 1
fi

echo -e "${GREEN}找到 Xray: $XRAY_CMD${NC}"

# 使用 xray 生成密钥对
KEY_PAIR=$($XRAY_CMD x25519)
if [ -n "$KEY_PAIR" ]; then
    PRIVATE_KEY=$(echo "$KEY_PAIR" | grep "Private key:" | awk '{print $3}')
    PUBLIC_KEY=$(echo "$KEY_PAIR" | grep "Public key:" | awk '{print $3}')
fi

# 验证密钥是否生成成功
if [ -z "$PUBLIC_KEY" ] || [ -z "$PRIVATE_KEY" ]; then
    echo -e "${YELLOW}xray x25519 失败，尝试使用 openssl 生成 X25519 密钥对...${NC}"
    # 使用 openssl 生成真正的 X25519 密钥对
    KEY_FILE=$(mktemp /tmp/x25519-key.XXXXXX.pem 2>/dev/null)
    if openssl genpkey -algorithm X25519 -out "$KEY_FILE" 2>/dev/null; then
        # PKCS#8 DER 格式尾部 32 字节即为 raw key
        # 需转为 URL-safe base64 (tr '+/' '-_')，xray 要求此格式
        PRIVATE_KEY=$(openssl pkey -in "$KEY_FILE" -outform DER 2>/dev/null | tail -c 32 | base64 -w0 | tr -d '=' | tr '+/' '-_')
        PUBLIC_KEY=$(openssl pkey -in "$KEY_FILE" -pubout -outform DER 2>/dev/null | tail -c 32 | base64 -w0 | tr -d '=' | tr '+/' '-_')
        rm -f "$KEY_FILE"
    else
        echo -e "${RED}密钥生成失败，请确保已安装最新版 Xray (xray x25519) 或 OpenSSL 1.1.1+${NC}"
        echo -e "${YELLOW}安装命令: bash -c \"\$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)\" @ install${NC}"
        exit 1
    fi
fi

# 生成 Short ID
SHORT_ID=$(openssl rand -hex 8)

# 伪装域名列表
FAKE_DOMAINS=(
    "www.microsoft.com"
    "www.apple.com"
    "www.cloudflare.com"
)
RANDOM_INDEX=$((RANDOM % ${#FAKE_DOMAINS[@]}))
SNI=${FAKE_DOMAINS[$RANDOM_INDEX]}

echo -e "${GREEN}✓ 配置生成完成${NC}"
echo -e "  - 端口: $RANDOM_PORT"
echo -e "  - UUID: $UUID"
echo -e "  - Private Key: ${PRIVATE_KEY:0:20}..."
echo -e "  - Public Key: ${PUBLIC_KEY:0:20}..."
echo -e "  - Short ID: $SHORT_ID"
echo -e "  - 伪装域名: $SNI"

# 创建 Xray 配置文件
mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json << EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $RANDOM_PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "$SNI:443",
          "xver": 0,
          "serverNames": [
            "$SNI"
          ],
          "privateKey": "$PRIVATE_KEY",
          "shortIds": [
            "$SHORT_ID"
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ]
}
EOF

# 验证配置文件
echo -e "${YELLOW}验证配置文件...${NC}"
if ! /usr/local/bin/xray run -test -config /usr/local/etc/xray/config.json > /dev/null 2>&1; then
    echo -e "${RED}配置文件验证失败，尝试修复...${NC}"
    # 显示错误详情
    /usr/local/bin/xray run -test -config /usr/local/etc/xray/config.json
    exit 1
fi
echo -e "${GREEN}✓ 配置文件验证通过${NC}"

# 重启 Xray
systemctl restart xray
systemctl enable xray

sleep 3
if systemctl is-active --quiet xray; then
    echo -e "${GREEN}✓ Xray 启动成功${NC}"
else
    echo -e "${RED}✗ Xray 启动失败，查看日志...${NC}"
    journalctl -u xray -n 20 --no-pager
    exit 1
fi

# 开放端口
echo -e "${YELLOW}开放端口 $RANDOM_PORT 和 25500${NC}"
if command -v ufw &> /dev/null; then
    ufw allow $RANDOM_PORT/tcp >/dev/null 2>&1
    ufw allow 25500/tcp >/dev/null 2>&1
    echo -e "${GREEN}✓ ufw 规则已添加${NC}"
elif command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-port=$RANDOM_PORT/tcp >/dev/null 2>&1
    firewall-cmd --permanent --add-port=25500/tcp >/dev/null 2>&1
    firewall-cmd --reload >/dev/null 2>&1
    echo -e "${GREEN}✓ firewalld 规则已添加${NC}"
else
    echo -e "${YELLOW}⚠ 未检测到防火墙，请手动确保端口开放${NC}"
fi

# ============================================
# 第二步：安装 subconverter
# ============================================
echo -e "${BLUE}[2/5] 安装 subconverter...${NC}"

SUB_DIR="/opt/subconverter"
rm -rf $SUB_DIR
mkdir -p $SUB_DIR
cd $SUB_DIR

# 下载 subconverter
wget -q --show-progress https://github.com/asdlokj1qpi233/subconverter/releases/latest/download/subconverter_linux64.tar.gz
if [ ! -f subconverter_linux64.tar.gz ]; then
    echo -e "${RED}subconverter 下载失败${NC}"
else
    tar -xzf subconverter_linux64.tar.gz
    
    # 修正路径
    if [ -d "subconverter" ]; then
        cd subconverter
    fi
    
    # 优先使用 TOML 配置（fork 版本主力格式）
    if [ -f "pref.example.toml" ]; then
        cp pref.example.toml pref.toml
        sed -i 's/listen = "127.0.0.1"/listen = "0.0.0.0"/g' pref.toml
        sed -i 's/port = 8080/port = 25500/g' pref.toml
    fi

    # INI 配置作为备用
    if [ -f "pref.ini" ]; then
        sed -i 's/127.0.0.1/0.0.0.0/g' pref.ini
        sed -i 's/8080/25500/g' pref.ini
    elif [ -f "config.ini" ]; then
        sed -i 's/127.0.0.1/0.0.0.0/g' config.ini
        sed -i 's/8080/25500/g' config.ini
    else
        cat > pref.ini << EOF
[common]
api_mode=true
default_url=
exclude_remarks=(到期|流量|时间|官网|网站)
auto_update=false
managed_config_prefix=

[server]
listen=0.0.0.0
port=25500
EOF
    fi
    
    # 创建 systemd 服务
    WORK_DIR=$(pwd)
    cat > /etc/systemd/system/subconverter.service << EOF
[Unit]
Description=Subconverter Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$WORK_DIR
ExecStart=$WORK_DIR/subconverter
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF
    
    systemctl daemon-reload
    systemctl enable subconverter
    systemctl restart subconverter
    
    sleep 2
    if systemctl is-active --quiet subconverter; then
        echo -e "${GREEN}✓ subconverter 启动成功${NC}"
    else
        echo -e "${YELLOW}⚠ subconverter 启动失败，尝试手动启动...${NC}"
        cd $WORK_DIR && nohup ./subconverter > /dev/null 2>&1 &
    fi
fi

# ============================================
# 第三步：生成 VLESS 链接
# ============================================
echo -e "${BLUE}[3/5] 生成 VLESS-Reality 链接...${NC}"

# URL 编码函数
url_encode() {
    if command -v python3 &> /dev/null; then
        python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
    else
        echo "$1" | sed 's/#/%23/g; s/@/%40/g; s/:/%3A/g'
    fi
}

VLESS_LINK="vless://$UUID@$SERVER_IP:$RANDOM_PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$SNI&fp=chrome&pbk=$PUBLIC_KEY&sid=$SHORT_ID&type=tcp&headerType=none#VLESS-Reality"

echo -e "${GREEN}✓ VLESS 链接已生成${NC}"
echo "$VLESS_LINK" > /root/vless-link.txt

# ============================================
# 第四步：生成 Clash 订阅链接
# ============================================
echo -e "${BLUE}[4/5] 生成 Clash 订阅链接...${NC}"

ENCODED_LINK=$(url_encode "$VLESS_LINK")
SUB_URL="http://$SERVER_IP:25500/sub?target=clash&url=$ENCODED_LINK&filename=$SUB_NAME"
echo "$SUB_URL" > /root/clash-subscription.txt

echo -e "${GREEN}✓ Clash 订阅链接已生成${NC}"

# ============================================
# 第五步：测试并输出
# ============================================
echo -e "${BLUE}[5/5] 测试连接...${NC}"

sleep 3
if curl -s "http://localhost:25500/version" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ subconverter 工作正常${NC}"
else
    echo -e "${YELLOW}⚠ subconverter 可能需要几秒启动，稍后可测试${NC}"
fi

# 测试 Xray 端口
if ss -tlnp | grep -q ":$RANDOM_PORT"; then
    echo -e "${GREEN}✓ Xray 正在监听端口 $RANDOM_PORT${NC}"
else
    echo -e "${YELLOW}⚠ 请检查防火墙是否开放端口 $RANDOM_PORT${NC}"
fi

# 最终输出
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}🎉 部署完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}📡 Clash 订阅地址 (填入 Clash 订阅栏):${NC}"
echo -e "${GREEN}$SUB_URL${NC}"
echo ""
echo -e "${YELLOW}🔗 VLESS 链接 (备用):${NC}"
echo -e "  $VLESS_LINK"
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}使用说明:${NC}"
echo -e "1. 复制上面的 Clash 订阅地址"
echo -e "2. 打开 Clash Verge / Clash Meta 客户端"
echo -e "3. 订阅管理 → 添加 → 粘贴地址 → 更新"
echo -e ""
echo -e "${BLUE}========================================${NC}"
echo -e "${YELLOW}文件保存位置:${NC}"
echo -e "  VLESS 链接: /root/vless-link.txt"
echo -e "  订阅地址: /root/clash-subscription.txt"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}✨ 脚本执行完毕！${NC}"
