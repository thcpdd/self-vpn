# VLESS-Reality + Clash 订阅一键部署脚本

在 Linux 服务器上一键部署 VLESS-Reality 代理，并自动生成 Clash 订阅链接。

## 快速使用

在 root 权限下直接运行以下命令即可：

```bash
bash <(curl -sL https://raw.githubusercontent.com/thcpdd/self-vpn/main/setup.sh)
```

> 注意：需以 root 身份运行，脚本会自动完成所有配置。

## 脚本原理

整个脚本分为 5 个步骤，在服务器上搭建了一套完整的代理 + 订阅转换链路：

```
┌─────────────┐     VLESS-Reality     ┌──────────────────┐
│  Clash 客户端 │ ◄──── 订阅拉取 ──── │  subconverter     │
│  (你的电脑)   │                      │  (订阅转换服务)   │
└─────────────┘                      └────────┬─────────┘
                                              │
                                     VLESS 链接 (原始格式)
                                              │
                                     ┌────────▼─────────┐
                                     │  Xray (代理服务)   │
                                     │  VLESS + Reality  │
                                     └──────────────────┘
```

### 脚本执行流程

#### 1. 安装 Xray 并配置 VLESS-Reality

- 安装 [Xray-core](https://github.com/XTLS/Xray-core)（若尚未安装）
- 生成随机端口（10000-50000）、UUID、X25519 密钥对、Short ID
- 从预设列表随机选取一个伪装域名（如 `www.microsoft.com`）
- 写入 Xray 配置文件 `/usr/local/etc/xray/config.json`
- 验证配置并启动 Xray 服务

关键配置项：

| 配置 | 说明 |
|------|------|
| `protocol: vless` | 使用 VLESS 协议 |
| `flow: xtls-rprx-vision` | 启用 XTLS Vision 流控 |
| `security: reality` | 使用 Reality 传输层加密 |
| `dest: $SNI:443` | 伪装成访问目标网站的 TLS 握手 |

#### 2. 安装 subconverter

- 下载 [subconverter](https://github.com/asdlokj1qpi233/subconverter)（订阅格式转换工具，fork 版，兼容 Reality 协议转换）
- 配置监听 `0.0.0.0:25500`
- 注册为 systemd 服务并自启

subconverter 的作用是将 VLESS 分享链接转换为 Clash 可识别的 YAML 订阅格式。

#### 3. 生成 VLESS 链接

拼接标准 VLESS-Reality 分享链接格式：

```
vless://UUID@SERVER_IP:PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=SNI&fp=chrome&pbk=PUBLIC_KEY&sid=SHORT_ID&type=tcp#VLESS-Reality
```

#### 4. 生成 Clash 订阅地址

将 VLESS 链接通过 subconverter 转换为 Clash 订阅：

```
http://SERVER_IP:25500/sub?target=clash&url=ENCODED_VLESS_LINK&filename=SUB_NAME
```

#### 5. 测试验证

- 测试 subconverter 接口是否正常响应
- 检查 Xray 端口是否监听
- 输出订阅地址和备用 VLESS 链接

## 自定义配置

编辑脚本顶部的变量：

```bash
SUB_NAME="My-VPN"   # Clash 订阅显示的名称
```

## 输出文件

| 文件 | 内容 |
|------|------|
| `/root/vless-link.txt` | VLESS 分享链接（备用） |
| `/root/clash-subscription.txt` | Clash 订阅地址 |

## 系统服务

| 服务 | 端口 | 说明 |
|------|------|------|
| `xray` | 随机端口 | 代理服务 |
| `subconverter` | 25500 | 订阅转换服务 |

## 技术栈

- **代理协议**: VLESS + Reality + XTLS Vision
- **加密传输**: Reality (TLS 1.3 指纹伪装)
- **订阅转换**: subconverter
- **客户端**: Clash Verge / Clash Meta / 任何支持 Clash 订阅的客户端
